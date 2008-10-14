Return-Path: <linux-kernel-owner+w=401wt.eu-S1753353AbYJNQ0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbYJNQ0A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 12:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbYJNQZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 12:25:50 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:40534 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbYJNQZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 12:25:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wley2bN2rhmBPtHnmga5bKpfk2tXPzv4rNQMspdm0bXbxx5LCnzaF16Q48VG7KhFDX
         r7H4Zdykfqi3S16OP6vJ9JjfJmQTDcjcrhoGNMs10313pNYksDQiFvfE3h6sp+P6rIv4
         NQxdhHPuVksDinuapr8DDnI+t59OPLN8b50Mk=
Message-ID: <c62985530810140925r147d99ddufa4236718d6d12d8@mail.gmail.com>
Date: Tue, 14 Oct 2008 18:25:48 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Julia Lawall" <julia@diku.dk>
Subject: Re : [PATCH 1/2] drivers/pci/hotplug/cpqphp_ctrl.c: Convert && to ||
Cc: kristen.c.accardi@intel.com, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0810141759300.20451@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0810141759300.20451@pc-004.diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/14, Julia Lawall <julia@diku.dk>:
> From: Julia Lawall <julia@diku.dk>
> The semantic patch that makes this change is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
>
> // <smpl>
> @disable and_comm@
> expression E;
> identifier fld;
> @@
>
> - !E && !E->fld
> + !E || !E->fld
> // </smpl>
>

What a great tool. :)
I guess you gathered a lot of precious patterns since the creation of
coccinelle!
