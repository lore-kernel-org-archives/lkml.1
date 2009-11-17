Return-Path: <linux-kernel-owner+w=401wt.eu-S1755949AbZKQMlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949AbZKQMlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 07:41:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755574AbZKQMlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 07:41:22 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51977 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753319AbZKQMlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 07:41:21 -0500
Date: Tue, 17 Nov 2009 12:41:25 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Kuninori Morimoto <morimoto.kuninori@renesas.com>,
       Magnus Damm <damm@opensource.se>, alsa-devel@alsa-project.org,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] Null suspend/resume functions
Message-ID: <20091117124125.GD823@rakim.wolfsonmicro.main>
References: <ud43sjtaf.wl%morimoto.kuninori@renesas.com>
 <20091109105858.GB1245@sirena.org.uk>
 <20091109133136.GC1245@sirena.org.uk>
 <20091116153000.GB29479@sirena.org.uk>
 <20091117115236.GB1376@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091117115236.GB1376@ucw.cz>
X-Cookie: That's no moon...
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 12:52:36PM +0100, Pavel Machek wrote:

> I believe that having few nop functions around the tree should not be
> huge problem. If it is, you can introduce one shared top function into
> the core...

The problem I have with that is that for most APIs noop functions are a
big fat warning sign that something is going wrong and the API is being
abused.  This then creates noise and code review problems in the driver
code since you've got something that normally suggests a problem.
