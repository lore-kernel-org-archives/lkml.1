Return-Path: <linux-kernel-owner+w=401wt.eu-S1759684AbYEPSSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759684AbYEPSSj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 14:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754516AbYEPSS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 14:18:28 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:59363 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099AbYEPSS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 14:18:27 -0400
Message-ID: <482DD052.80201@keyaccess.nl>
Date: Fri, 16 May 2008 20:20:02 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Stas Sergeev <stsp@aknet.ru>
CC: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
       Theodore Tso <tytso@mit.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roberto Oppedisano <roberto.oppedisano@infracom.it>
Subject: Re: [alsa-devel] [patch] snd-pcsp: put back the compatibility code
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera>	<88YBFoyd1CN.A._sF.Ov1JIB@chimera>	<s5hskwmeb1h.wl%tiwai@suse.de>	<20080514212011.GH7054@mit.edu>	<s5hhcd0azv1.wl%tiwai@suse.de>	<20080515130654.GC18825@mit.edu>	<s5h8wybr0c2.wl%tiwai@suse.de> <482DCE53.1000406@aknet.ru>
In-Reply-To: <482DCE53.1000406@aknet.ru>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: 0.0 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16-05-08 20:11, Stas Sergeev wrote:

> The attached patch adds back the
> compatibility code, allowing the
> driver to work with older alsa-libs.
> The removal was premature, it breaks
> the real-life configs, I am sorry
> about that.
> 
> Takashi, could you please apply?
> It is a straight-forward revert of:
> http://hg-mirror.alsa-project.org/alsa-kernel/diff/26b0243ab4fa/drivers/pcsp/pcsp_lib.c

Thanks. Probably .26 material; many people will likely just disable the 
driver upon not seeing it work (and not re-enable it later also, meaning 
it might be a very largely unused driver) otherwise.

Rene.
