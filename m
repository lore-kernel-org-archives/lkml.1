Return-Path: <linux-kernel-owner+w=401wt.eu-S1756423AbZDTO42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423AbZDTO42 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 10:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755850AbZDTO4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 10:56:17 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:53916 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595AbZDTO4R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 10:56:17 -0400
MIME-Version: 1.0
In-Reply-To: <20090420143606.4309C74804E@mail192-wa4.bigfish.com>
References: <764365e7af2e476e43cd674738e51f13b306979b.1239874968.git.monstr@monstr.eu> 
	<74c0088dfda1816c21914c0a8da0c42908526c5e.1239874968.git.monstr@monstr.eu> 
	<20090417170707.B6C95C4004F@mail150-wa4.bigfish.com> <fa686aa40904172249m5e261492w48c8d9d8446600e0@mail.gmail.com> 
	<495563870904181941o5a66126dgb59d8cad2b7a66f2@mail.gmail.com> 
	<1d3f23370904191603s37a6a34clccc397707394650b@mail.gmail.com> 
	<977C41F842E66D4CB2E41332313B6150069D3D27@XSJ-EXCHVS1.xlnx.xilinx.com> 
	<20090420143606.4309C74804E@mail192-wa4.bigfish.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 20 Apr 2009 08:48:06 -0600
Message-ID: <fa686aa40904200748t4fc0b623naf7fd8c34a743733@mail.gmail.com>
Subject: Re: [microblaze-uclinux] [PATCH 11/11] microblaze: Kconfig: Enable 
	drivers for Microblaze
To: John Linn <John.Linn@xilinx.com>
Cc: Stephen Neuendorffer <stephenn@xilinx.com>,
       John Williams <john.williams@petalogix.com>,
       microblaze-uclinux@itee.uq.edu.au,
       linuxppc-dev <linuxppc-dev@ozlabs.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20, 2009 at 8:36 AM, John Linn <John.Linn@xilinx.com> wrote:
>> -----Original Message-----
>> From: Stephen Neuendorffer
>> Sent: Sunday, April 19, 2009 11:52 PM
>> To: John Williams; microblaze-uclinux@itee.uq.edu.au
>> Cc: grant.likely@secretlab.ca; linuxppc-dev; linux-kernel@vger.kernel.org; John Linn
>> Subject: RE: [microblaze-uclinux] [PATCH 11/11] microblaze: Kconfig: Enable drivers for Microblaze
>>
>>
>> My thinking is that these drivers are likely to be used as a group,
>> hence it would be nice to make it easy to get them all visible/enabled somehow.
>>
>> Steve
>
>
> It seems like John's suggestion of no arch filters would satisfy that also. Since FPGAs are used in so many different applications this would seem to open the drivers up to everyone regardless of what processor they're using. It's certainly less complex so I like it in that way.
>
> But maybe I'm missing something here and there's a downside?

No, I don't think there is.

I think CONFIG_OF is the right thing to do.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
