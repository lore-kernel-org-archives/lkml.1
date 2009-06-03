Return-Path: <linux-kernel-owner+w=401wt.eu-S1755045AbZFCTnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045AbZFCTnT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 15:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbZFCTnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 15:43:11 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:38920 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbZFCTnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 15:43:10 -0400
Date: Wed, 3 Jun 2009 21:45:26 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Robert Berger <robert.berger@reliableembeddedsystems.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: http://patchwork.kernel.org/patch/26483/ broke my system boot
Message-ID: <20090603194526.GG3100@uranus.ravnborg.org>
References: <20090603143944.GF29326@balbir.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090603143944.GF29326@balbir.in.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 03, 2009 at 10:39:44PM +0800, Balbir Singh wrote:
> After spending some time figuring out why my system failed to reboot,
> checking config options, kernel version, modules installed. I figured
> out that the patch in http://patchwork.kernel.org/patch/26483/ broke
> the system boot on the latest mmotm. Reverting it helped my system
> call depmod and hence boot.
> 
> The patch is really unhelpful, since the changelog is completely
> empty. Sigh!

Yeah, sorry for not nak'ing it earlier. Has been busy.
Andrew removed it from -mm and I notified the author about the
problems with the patch (in private mail it seems - I just replied to what I had).

	Sam
