Return-Path: <linux-kernel-owner+w=401wt.eu-S932115AbZD0Smo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115AbZD0Smo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 14:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758451AbZD0SmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 14:42:10 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:49423 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757663AbZD0SmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 14:42:08 -0400
Date: Mon, 27 Apr 2009 20:44:17 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tim Abbott <tabbott@MIT.EDU>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 4/8] powerpc: Use TEXT_TEXT macro in linker script.
Message-ID: <20090427184417.GD12056@uranus.ravnborg.org>
References: <1240855347-19316-1-git-send-email-tabbott@mit.edu> <1240855347-19316-2-git-send-email-tabbott@mit.edu> <1240855347-19316-3-git-send-email-tabbott@mit.edu> <1240855347-19316-4-git-send-email-tabbott@mit.edu> <1240855347-19316-5-git-send-email-tabbott@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240855347-19316-5-git-send-email-tabbott@mit.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 02:02:23PM -0400, Tim Abbott wrote:
> Rather than adding .ref.text to the powerpc linker script so that we
> can use __REF on the powerpc architecture, it seems simpler to switch
> to using the generic TEXT_TEXT macro.
> 
> Signed-off-by: Tim Abbott <tabbott@mit.edu>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
> ---
>  arch/powerpc/kernel/vmlinux.lds.S |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
> index d7425ff..433ae11 100644
> --- a/arch/powerpc/kernel/vmlinux.lds.S
> +++ b/arch/powerpc/kernel/vmlinux.lds.S
> @@ -54,7 +54,8 @@ SECTIONS
>  		ALIGN_FUNCTION();
>  		HEAD_TEXT
>  		_text = .;
> -		*(.text .fixup .text.init.refok .exit.text.refok __ftr_alt_*)
> +		TEXT_TEXT
> +		*(.fixup __ftr_alt_*)
>  		SCHED_TEXT
>  		LOCK_TEXT
>  		KPROBES_TEXT
> -- 
> 1.6.2.1
> 
