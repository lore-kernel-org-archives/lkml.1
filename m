Return-Path: <linux-kernel-owner+w=401wt.eu-S933888AbXDAS4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933888AbXDAS4e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 14:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933897AbXDAS4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 14:56:33 -0400
Received: from ik-out-1112.google.com ([66.249.90.180]:43435 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933888AbXDAS4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 14:56:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=QXsq3s66f1YS2OItu3P0M/0Q9meAQA00UttzOyqyNeYV/63ydWwYE7Htt/Lhc5twLXElqP6iZYZBEemclnsplYi7JtANFxDbMyNcbvVdkfZ8incFh+CFXNhkqtbnuTI2bceGwTbsV4sMZuxz4QPR5D6CHTPqonFyMmehjXDV5DY=
Message-ID: <478c16ae0704011156u5a34ae96lfd88a6da16d5726a@mail.gmail.com>
Date: Sun, 1 Apr 2007 15:56:30 -0300
From: "Edgardo Hames" <ehames@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Rebuilding and checksumming the Linux kernel
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm working on a project with teams spread across the world and we all
work on the same repository patching the kernel and then integrating
into a common main branch. Even though we label the source code, we
would like to make sure that we are all building the same kernel by
running md5sum on the resulting binary.

Right now, this is not possible because the kernel includes a
timestamp and a build number on the binary. What are this timestamps
used for? Can we just remove them? Is there any other thing that may
lead to different binaries? (we are using the exact toolchains and
build machines, so we can assume that the same executable is generated
if the input source is the same).

Please, cc me in your replies because I'm not subscribed to the list.

Thanks for your time,
Ed
