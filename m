Return-Path: <linux-kernel-owner+w=401wt.eu-S1754490AbYCZDh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbYCZDh5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 23:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbYCZDhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 23:37:50 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:61750 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbYCZDht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 23:37:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=SZDb9QbAdw4MMXD4+tWsJzTGauRJ9d9NmzwUH+PmCOwkm1y44QRJI45d3N8s4c1x5XBXmXfctQyjp/XQaEbTuquea9qUES/xKeFxUchK6XzvyHBXBaZ+0uzhbtFp/cYR9U0mxBRhKYm4bnQIjoeDW8cuN2vxOI0kpsAmNXawpOE=
Message-ID: <47E9C50B.1030508@gmail.com>
Date: Tue, 25 Mar 2008 23:37:47 -0400
From: Fei Liu <feiliu4@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080202 SeaMonkey/1.1.8
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: A question to Frank Kingswood about ch340/341 support for 2.4.18
  kernel
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 2008-03-26 03:36, Fei Liu wrote:
>
> Is there any chance this driver [ch341] can be back ported to
> 2.6.18 for opensuse 10.2 system? It seems the usb kernel data
> structures had some significant changes from 2.6.18 to 2.6.24.

They indeed have, and probably not insignificant.

ftp://ftp5.gwdg.de/pub/linux/misc/suser-jengelh/SUSE-10.3/ (and
../SRPMS/) contains ch341-2.6.23.99rc7-1593.{i586,x86_64,src}.rpm for
2.6.23(.17) (and such kernel is available through this repository).
Maybe it helps though you said you have 10.2.

Well yes it's SUSE10.2 with 2.6.18. I know the '-mm' ch341 patch was 
applied to 2.6.23 which already had the data structure changes.. The 
problem for me is I have a bunch of  softwares that require kernel 
modules to work (fpga stuff, X11, etc..), it's a pain to rebuild every 
other modules if I could only get ch341  to work with 2.6.18 kernel.

Fei
