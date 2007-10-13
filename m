Return-Path: <linux-kernel-owner+w=401wt.eu-S1759520AbXJMIpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759520AbXJMIpV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 04:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbXJMIpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 04:45:08 -0400
Received: from smtp105.plus.mail.mud.yahoo.com ([68.142.206.238]:46432 "HELO
	smtp105.plus.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751326AbXJMIpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 04:45:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=KqlREk5Bot3lV6w3VG9txLw2gk0N30R711loA+euhvjuMpMNv33yehVnCyGXcFQzB3RCSc/cZ4ShIyjkr2whK/Mp3zG9xVUNjssBZgELub1mGb6J9Qd/7nj/KRaPv66AwB4oZVDiJZdDAY1+6LLnTprZVja7ip64VSkgp9jp8aI=  ;
X-YMail-OSG: xsAxxPQVM1mHAzKs.N2LCBOa.EydKf.53_r_lk1PHluZS5mqC8GnbudRjbVABMl7z1nmHerzWGWtTRmrHsGylUS0aAJvVcCsK58r_v.xvG4YzE4y0lw-
Date: Sat, 13 Oct 2007 10:44:55 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Eugene Teo <eugeneteo@kernel.sg>
Subject: Re: -mm merge plans for 2.6.24
Message-ID: <20071013084455.GA5656@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2007 at 02:22:22PM -0700, Andrew Morton wrote:
<snip>
> #increase-at_vector_size-to-terminate-saved_auxv-properly.patch: Tony wanted enhancements
> increase-at_vector_size-to-terminate-saved_auxv-properly.patch
> change-inotifyfs-magic-as-the-same-magic-is-used-for-futexfs-v2.patch
> delay-creation-of-khcvd-thread.patch
> hvc-console-is-also-used-by-iseries-so-add-that-to-hvc_driver-help.patch
> lockdep-give-each-filesystem-its-own-inode-lock-class.patch
> menuconfig-transform-nls-and-dlm-menus.patch
> menuconfig-transform-network-filesystems-menu.patch
> fs-udf-ballocc-mark-a-variable-as-uninitialized_var.patch
> jbd-config_jbd_debug-cannot-create-proc-entry.patch
> jbd-config_jbd_debug-cannot-create-proc-entry-fix.patch
> jbd-fix-commit-code-to-properly-abort-journal.patch
> jbd-fix-jbd-warnings-when-compiling-with-config_jbd_debug.patch
> dont-truncate-proc-pid-environ-at-4096-characters.patch
> fix-wrong-filename-reference-in-drivers-testingtxt.patch
> anon-inodes-use-open-coded-atomic_inc-for-the-shared-inode.patch
> ncr53c8xx-remove-deprecated-irq-flags-sa_.patch
> completely-remove-deprecated-irq-flags-sa_.patch
> compile-handle_percpu_irq-even-for-uniprocessor-kernels.patch
> fs-correct-sus-compliance-for-open-of-large-file-without.patch
> ext3-remove-ifdef-config_ext3_index.patch
> rename-signalfd_siginfo-fields.patch
> break-elf_platform-and-stack-pointer-randomization-dependency.patch
> spin_lock_unlocked-cleanups.patch
> binfmt_flat-minimum-support-for-the-blackfin-relocations.patch
> binfmt_flat-minimum-support-for-the-blackfin-relocations-checkpatch-fixes.patch
> 
>   The infamous misc.  Will re-review and will merge basically all of them.
can you please add http://lkml.org/lkml/2007/7/30/98 also to the misc-queue for
the warning still persists and the patch is good to go as is (against current git
v2.6.23-2840-g752097c, for example) albeit with a little fuzziness.
-- 
Regards/Gruﬂ,
    Boris.
