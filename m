Return-Path: <linux-kernel-owner+w=401wt.eu-S1753771AbYE2Aqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771AbYE2Aqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 20:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756117AbYE2AqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 20:46:25 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:16392 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756097AbYE2AqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 20:46:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=aSWOOeCpO7BohYGNOCWpJHhYjzZpdrcQEQz0npZLLKS9OnwP3xOMWowxUQ6jOtKiho+1FPIA7Xeo9so+/VqhgWiPnycZZFpJkpc+OeZURYcQvn7LZPRqVHK0vE/W7oJF/UWZCXoGQkwiWY2qgh4ZzxGsqnxkRWZFbkwp9OILNo8=
Message-ID: <21d7e9970805281746k71b47ed2i79c06288d2dca022@mail.gmail.com>
Date: Thu, 29 May 2008 10:46:22 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "kernel list" <linux-kernel@vger.kernel.org>,
       dri-devel <dri-devel@lists.sourceforge.net>
Subject: in-kernel DRM tree move around....
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

So I've been growing more annoyed with the current layout of the drm
tree in the kernel,

a) it lives under char.
b) everything in one directory.
c) header files in one directory.
d) no header files exposed to userspace.

http://git.kernel.org/?p=linux/kernel/git/airlied/drm-2.6.git;a=commitdiff;h=7df9a948d0f849466e3de259cccb49bc54cbad68

is a proposal to create drivers/gpu/drm, (I may move AGP in there as
well later). It also creates per-driver subdirs.

This to me solves the a-d problems.

There is also an out-of-tree kernel drm which I'll probably give some
more thought later.

Dave.
