Return-Path: <linux-kernel-owner+w=401wt.eu-S1756793AbZCVXnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793AbZCVXnH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 19:43:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754590AbZCVXmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 19:42:54 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:53551 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589AbZCVXmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 19:42:53 -0400
Date: Mon, 23 Mar 2009 00:42:48 +0100
From: Daniel Mack <daniel@caiaq.de>
To: =?iso-8859-1?Q?=C9ric?= Piel <eric.piel@tremplin-utc.net>
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 4/5] lis3: solve dependency between core and ACPI
Message-ID: <20090322234248.GG22927@buzzloop.caiaq.de>
References: <49AD8B0A.90901@tremplin-utc.net> <1236131099-8082-1-git-send-email-daniel@caiaq.de> <1236131099-8082-2-git-send-email-daniel@caiaq.de> <49C6C8DE.7020405@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49C6C8DE.7020405@tremplin-utc.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 12:25:18AM +0100, Éric Piel wrote:
> > This solves the dependency between lis3lv02d.[ch] and ACPI specific
> > methods. It introduces a ->bus_priv pointer to the device struct which
> > is casted to 'struct acpi_device' in the ACIP layer. Changed hp_accel.c
> > accordingly.
> Sorry for the long delay. Eventually I've found time to test the patch
> and fix a bug: the axis conversion was set too late, preventing the
> calibration to work.
> 
> The attached patch should make your modifications fully working with the
> hp laptops :-)
> I guess the best is to fold it into your patch and I'll ack the new
> version.

Ok, thanks :)

Three patches following this mail - I left out the first two I was
repeatedly sending previously as they're in Andrew's tree already.

Daniel

