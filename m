Return-Path: <linux-kernel-owner+w=401wt.eu-S1751941AbYBJOeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941AbYBJOeU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 09:34:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144AbYBJOeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 09:34:09 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:17071 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbYBJOeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 09:34:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=KExguyryhqRte1sDyChsbgLN6ugs+ICPtAP8c3l+kmycjTLA8HtTmYNy0oa5IWLbFfpgoaH7tkxYUcM3hMy619GYhUAeWNcoBFNUQDYLvof9IUTj9v3ycBqiCnfgq7vdrli2wo3QVh6kwyX7ajhdbuByW9AFRk1219Pv2Km90i8=
Date: Sun, 10 Feb 2008 15:33:02 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Andy Whitcroft <apw@shadowen.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: bug in checkpatch (on pointers to typedefs?)
Message-ID: <20080210143240.GA13317@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Checkpatch in current mainline outputs following errors:

$ ./scripts/checkpatch.pl -q --file ./fs/udf/misc.c
ERROR: need consistent spacing around '*' (ctx:WxV)
#205: FILE: fs/udf/misc.c:205:
+       tag *tag_p;
            ^

$ ./scripts/checkpatch.pl -q --file ./fs/udf/unicode.c
ERROR: need consistent spacing around '*' (ctx:WxV)
#48: FILE: fs/udf/unicode.c:48:
+int udf_build_ustr(struct ustr *dest, dstring *ptr, int size)
                                               ^
(...)

I think the code is ok.

Marcin
