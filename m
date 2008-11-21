Return-Path: <linux-kernel-owner+w=401wt.eu-S1757870AbYKUQ7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870AbYKUQ7o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 11:59:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755413AbYKUQ7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 11:59:36 -0500
Received: from rn-out-0910.google.com ([64.233.170.190]:17450 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755251AbYKUQ7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 11:59:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=KydV86fI9EzpJbk6ZS/YuM/V8x+EeG4+gpPx0Fdj/XfGSSk/dPZ0T/GxoAZPZbjA2x
         VSxEBs6Oz5g5cSkjnzwzve55QtQJ6X3a2iUkYZm5tE3+lYKRvf9/2U0rulsFcdbRLkor
         PCv6VEwecKVHaf0fTY/qwGCZFT7ecuis+Osww=
Message-ID: <e38d12ff0811210859r7103c20nb1bf9c6e5025d1c5@mail.gmail.com>
Date: Fri, 21 Nov 2008 11:59:32 -0500
From: "Andrey Vul" <andrey.vul@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Bad inodes and ESTALE
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why do files/directories located on unreadable inodes cause ESTALE
when trying to access ( open()) or modify (unlink()) them?
I know it's caused by a bad inode because fsck -f fixes all of the problems.

-- 
Andrey Vul
