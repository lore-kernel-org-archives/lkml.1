Return-Path: <linux-kernel-owner+w=401wt.eu-S1757989AbZKXGcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989AbZKXGcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 01:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757704AbZKXGcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 01:32:16 -0500
Received: from smtp.nokia.com ([192.100.122.230]:36005 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757484AbZKXGcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 01:32:16 -0500
Subject: Re: linux-next: ubifs tree build failure
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Corentin Chary <corentincj@iksaif.net>
In-Reply-To: <20091124121415.dc1e98a0.sfr@canb.auug.org.au>
References: <20091124121415.dc1e98a0.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Tue, 24 Nov 2009 08:31:54 +0200
Message-Id: <1259044314.18407.51.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 24 Nov 2009 06:31:59.0815 (UTC) FILETIME=[D3A27570:01CA6CCF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-24 at 02:14 +0100, Stephen Rothwell wrote:
> Hi Artem,
> 
> Today's linux-next build (x86_64 allmodconfig) failed like this:
> 
> fs/ubifs/super.c: In function 'open_ubi':
> fs/ubifs/super.c:1866: error: implicit declaration of function 'ubi_open_volume_path'
> fs/ubifs/super.c:1866: warning: assignment makes pointer from integer without a cast
> 
> Caused by commit 82ccbf8c4ec2113d4e73dbac3ca914019ca883ca ("UBIFS:
> support mounting of UBI volume character devices") which I have reverted
> for today.

Stephen,

thanks for quick reaction and sorry for the hassle. I've just fixed this
up.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

