Return-Path: <linux-kernel-owner+w=401wt.eu-S1753053AbZBQNyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053AbZBQNyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 08:54:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbZBQNyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 08:54:06 -0500
Received: from smarthost01.mail.zen.net.uk ([212.23.3.140]:41700 "EHLO
	smarthost01.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751830AbZBQNyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 08:54:05 -0500
Subject: Re: [PATCH 2/2] niu: improve ethtool support for gigabit copper
	cards
From: Ben Hutchings <bhutchings@solarflare.com>
To: Constantin Baranov <baranov@mercdev.com>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090217154334.97837477.baranov@mercdev.com>
References: <20090217154334.97837477.baranov@mercdev.com>
Content-Type: text/plain
Organization: Solarflare Communications
Date: Tue, 17 Feb 2009 13:53:57 +0000
Message-Id: <1234878837.3183.4.camel@achroite>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost01-IP: [82.69.137.158]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-17 at 15:43 +0400, Constantin Baranov wrote:
> Introduced support for link speed and duplex setting (ethtool -s),
> link advertising parameters and autonegotiation (ethtool -r):
[...]

I haven't looked closely at this, but is there anything here that can't
be handled by mii_get_settings() and other functions in the mii driver?

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

