Return-Path: <linux-kernel-owner+w=401wt.eu-S1759480AbXFQOYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759480AbXFQOYq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 10:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760378AbXFQOYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 10:24:19 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:19784 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760309AbXFQOYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 10:24:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:content-type:content-transfer-encoding:from;
        b=n8ZGmFt1WMVTiOPp6sQ/4ja76s0zOC3IEVMbphRNeNGpEJ+tw0dYJrwTk8ogVJJMxafexu3iKqRzUd4rCOriO8zqCtcbKQwSlySzq5KK4mWl2g+qj35IbgesT5jx27dTdNgjkD/6LcI1fifS9ck0XzT4yh3c2W8woRgV/jKONvU=
Message-ID: <467543FA.60905@googlemail.com>
Date: Sun, 17 Jun 2007 16:23:54 +0200
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Ingo Molnar <mingo@elte.hu>, "Darrick J. Wong" <djwong@us.ibm.com>,
       Andi Kleen <ak@suse.de>,
       =?ISO-8859-2?Q?Bj=F6rn_Steinbrink?= <B.Steinbrink@gmx.de>,
       Ian McDonald <ian.mcdonald@jandi.co.nz>,
       William Cohen <wcohen@redhat.com>,
       "S. P. Prasanna" <prasanna@in.ibm.com>,
       Antonino Daplas <adaplas@gmail.com>, Olaf Hering <olaf@aepfle.de>,
       =?ISO-8859-2?Q?Ville_Syrj=E4l=E4?= <syrjala@sci.fi>,
       Jean Delvare <khali@linux-fr.org>, Rudolf Marek <r.marek@assembler.cz>,
       Soeren Sonnenburg <kernel@nn7.de>
Subject: [1/2] 2.6.22-rc5: known regressions with patches
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc5
with patches available.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions



Unclassified

Subject    : CONFIG_DEBUG_RODATA prevents kprobes from working on 2.6.22-rc2
References : http://lkml.org/lkml/2007/5/23/202
Submitter  : William Cohen <wcohen@redhat.com>
             Ian McDonald <ian.mcdonald@jandi.co.nz>
Handled-By : S. P. Prasanna <prasanna@in.ibm.com>
Patch      : http://lkml.org/lkml/2007/6/7/2
Status     : patch available

Subject    : long freezes on thinkpad t60
References : http://lkml.org/lkml/2007/5/24/100
Submitter  : Miklos Szeredi <miklos@szeredi.hu>
Handled-By : Ingo Molnar <mingo@elte.hu>
Patch      : http://lkml.org/lkml/2007/6/16/81
Status     : patch was suggested

Subject    : OProfile issues
References : http://lkml.org/lkml/2007/6/12/207
Submitter  : Stephane Eranian <eranian@hpl.hp.com>
Handled-By : Björn Steinbrink <B.Steinbrink@gmx.de>
Patch      : http://lkml.org/lkml/2007/6/12/392
Status     : patch was suggested



FBDEV

Subject    : mach64 breakage in 2.6.22
References : http://lkml.org/lkml/2007/6/14/73
Submitter  : Olaf Hering <olaf@aepfle.de>
Handled-By : Ville Syrjälä <syrjala@sci.fi>
Patch      : http://lkml.org/lkml/2007/6/14/273
Status     : patch was suggested



HWMON

Subject    : latest coretemp changes break s2ram
References : http://lkml.org/lkml/2007/6/16/173
Submitter  : Soeren Sonnenburg <kernel@nn7.de>
Caused-By  : Rudolf Marek <r.marek@assembler.cz>
             commit 67f363b1f6a31cf5027a97372f64bcced4f05ba6
Handled-By : Jean Delvare <khali@linux-fr.org>
Patch      : http://lkml.org/lkml/2007/6/16/177
Status     : patch available



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
