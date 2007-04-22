Return-Path: <linux-kernel-owner+w=401wt.eu-S1030918AbXDVUft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030918AbXDVUft (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 16:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030931AbXDVUft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 16:35:49 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:49747 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030918AbXDVUfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 16:35:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type;
        b=mD6dJ4nHMc/3r/qMGhIs9MTG19JPYAvB52eiYuEKXeAqcrEuCeQsuidmu2pJfQtOM9A4AQM+vBWHPPCaAuYIbkfRMQeJG2y8yD1cvvoY0ZRanaqqEfph0z2UhKARGe7QkfRq6fSYfgoF9LJqmCHmH7QsryHuerk5uPbMKmaTI7U=
Message-ID: <2e4afe1e0704221335y6d4c84d8id65e71826ce60acb@mail.gmail.com>
Date: Mon, 23 Apr 2007 02:05:47 +0530
From: "Karuna sagar K" <karunasagark@gmail.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: ChunkFS - measuring cross-chunk references
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_156904_28539737.1177274147224"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_156904_28539737.1177274147224
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

The attached code contains program to estimate the cross-chunk
references for ChunkFS file system (idea from Valh). Below are the
results:

test on ext3, / partition-1 on 27 March 2007
Number of files = 217806
Number of directories = 24295
Total size = 8193116 KB
Total data stored = 7557892 KB
Size of block groups = 131072 KB
Number of inodes per block group = 16288
Total no. of cross references = 60657
------------------------------------------------
test on ext3, / partition-1 on 22 March 2007
Number of files = 230615
Number of directories = 24243
Total size = 8193116 KB
Total data stored = 7167212 KB
Size of block groups = 131072 KB
Number of inodes per block group = 16288
Total no. of cross references = 62163
------------------------------------------------
test on ext3, / partition-2 on 22 March 2007
Number of files = 79509
Number of directories = 6397
Total size = 3076888 KB
Total data stored = 1685100 KB
Size of block groups = 131072 KB
Number of inodes per block group = 16032
Total no. of cross references = 17996
---------------------------------------------------------------------------
test on ext3, /home partition-3 on 20 April 2007
Number of files = 157632
Number of directories = 13652
Total size = 10233404 KB
Total data stored = 9490196 KB
Size of block groups = 131072 KB
Number of inodes per block group = 16224
Total no. of cross references = 27184
---------------------------------------------------------------------------

Comments??

Thanks,
Karuna

------=_Part_156904_28539737.1177274147224
Content-Type: application/x-bzip2; name=cref.tar.bz2
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f0ty942n
Content-Disposition: attachment; filename="cref.tar.bz2"

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
ekC8F1hrH/UpUFjvIX/F3JFOFCQjxbVjQA==
------=_Part_156904_28539737.1177274147224--
