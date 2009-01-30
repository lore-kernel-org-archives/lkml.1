Return-Path: <linux-kernel-owner+w=401wt.eu-S1754785AbZA3JEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbZA3JEh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 04:04:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753463AbZA3JD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 04:03:59 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:63212 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbZA3JD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 04:03:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=aYidULqOarTYzT5rBbGBvgKd1p1wRwthR9d1aoi0cmFfpESZQmtPqkJ23gpcwa5z0N
         u74YZvBGbxd0CvBK/HIhiASsE7zzYuANx0/CdZKSwlD9cUu14uoghDKEzIZ3Aqf3DkyU
         bvSlkLqHS5LTb16eX/2BkpU0IHe8Ts3GiSGq0=
MIME-Version: 1.0
Date: Fri, 30 Jan 2009 01:03:56 -0800
Message-ID: <5f695cd0901300103o31cb92f4o9feb8c598465617c@mail.gmail.com>
Subject: Is there a way to set the order of initialization of different 
	systems ?
From: George Kumar <grgkumar4@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I would like to explore if there is a way so that I can set the order
of initialization of different kernel sub systems. The main reason I
would like to do this is because I have a network driver built
statically in the kernel which wants to download firmware from the
disk, but the IDE subsystem and root FS is not mounted yet so it
basically hangs for a minute waiting to dowload firmware and then
proceeds with the boot sequence. If I could ensure that IDE subsys is
initialized and root FS is mounted before networking is initialized,
this problem probably will not occur.

Thanks.
George.
