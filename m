Return-Path: <linux-kernel-owner+w=401wt.eu-S1764704AbZAONvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764704AbZAONvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 08:51:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755955AbZAONvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 08:51:37 -0500
Received: from mail150.ix.emailantidote.com ([89.167.219.150]:2364 "EHLO
	iamp03.mxsweep.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753798AbZAONvh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 08:51:37 -0500
X-Greylist: delayed 533 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Jan 2009 08:51:36 EST
Message-ID: <496F3344.9060104@draigBrady.com>
Date: Thu, 15 Jan 2009 12:59:48 +0000
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
CC: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
References: <200901020207.30359.rob@landley.net> <200901021026.37905.a.miskiewicz@gmail.com> <20090102094934.GB17841@infradead.org> <495DE995.1070002@opensde.org> <yw1x3ag2t2gd.fsf@thrashbarg.mansr.com>
In-Reply-To: <yw1x3ag2t2gd.fsf@thrashbarg.mansr.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 15 Jan 2009 13:42:09.0743 (UTC) FILETIME=[10412DF0:01C97717]
x-MXSweep-KeywordsCount: 0
x-MXSweep-MetaScanResult: Clean
x-MXSweep-MetaScanThreat: 
x-MXPurifier-SpamScore: 0
x-MXPurifier-VirusScore: 0
X-MXSweep-Threat: Clean
X-MXUniqueID: f2d7b3ff-8a65-452b-b745-24694424aec8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Måns Rullgård wrote:
> Alejandro Mery <amery@opensde.org> writes:
> 
>> I think the $(( ... )) bash-ism can be replaced with a simple .c helper toy.
> 
> The $(( ... )) construct is standard POSIX shell syntax, see
> http://www.opengroup.org/onlinepubs/000095399/utilities/xcu_chap02.html#tag_02_06_04
> 
> Bash supports $[ ... ] as an alternate syntax for the same thing.
> Perhaps you were thinking of that.

I think the misconception that $(( ... )) is a bashism is caused by
the wrong highlighting defaults chosen by vim. To fix this add this to ~/.vimrc

let g:is_posix = 1

That will also allow you to use the $(command) POSIX construct.
BTW, the vim syntax maintainers don't agree with changing this default:
http://groups.google.com/group/vim_dev/browse_thread/thread/41139a32772b2f5f

cheers,
Pádraig.
