Return-Path: <linux-kernel-owner+w=401wt.eu-S1753341Ab0AKMMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab0AKMMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 07:12:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322Ab0AKMMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 07:12:15 -0500
Received: from kotten8a.marieberg.ac ([213.238.238.22]:53951 "HELO
	iluvatar.nyren.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753116Ab0AKMMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 07:12:14 -0500
Content-Type: text/plain; charset=iso-8859-1; format=flowed; delsp=yes
To: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Bug found in ext3 quota enabled fs
References: <op.u6b72biaumhi3g@fujje.vpn.nyren.net>
 <20100111093628.GA16080@khazad-dum.debian.net>
Date: Mon, 11 Jan 2010 13:12:33 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Ralf Nyren" <ralf@nyren.net>
Message-ID: <op.u6dau7c5umhi3g@fujje.vpn.nyren.net>
In-Reply-To: <20100111093628.GA16080@khazad-dum.debian.net>
User-Agent: Opera Mail/10.10 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jan 2010 10:36:28 +0100, Henrique de Moraes Holschuh  
<hmh@hmh.eng.br> wrote:

> On Sun, 10 Jan 2010, Ralf Nyren wrote:
>> I did an rsync of a remote file to a local ext3 filesystem with  
>> journaled
>> quotas enabled. Got the kernel BUG report below... I was able to  
>> reproduce
>
> http://lkml.org/lkml/2010/1/7/439
>

Thanks! The patch solved the problem.
/Ralf
