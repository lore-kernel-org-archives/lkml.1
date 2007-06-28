Return-Path: <linux-kernel-owner+w=401wt.eu-S1762358AbXF1LTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762358AbXF1LTg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 07:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759841AbXF1LT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 07:19:29 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:33871 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758701AbXF1LT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 07:19:28 -0400
Message-ID: <46839864.8090002@gmail.com>
Date: Thu, 28 Jun 2007 13:15:48 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Patrick Draper <pdraper@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
References: <200706271825.17459.ahartmetz@gmail.com> <46829E82.6080804@gmail.com> <200706272110.50744.ahartmetz@gmail.com> <4682EEDD.4020501@gmail.com> <4682FE5C.5070004@gmail.com> <468315AF.1080105@gmail.com> <46831CD8.8000502@gmail.com>
In-Reply-To: <46831CD8.8000502@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2007 04:28 AM, Rene Herman wrote:

> On 06/28/2007 03:58 AM, Rene Herman wrote:
> 
>> to figure it out. If you need to specify an ALSA device somewhere, make
>> sure it's not the old "hw:0" but "default" (or "default:0" for the
>> first card, "default:1" for the second, ...). The "hw:N" devices don't
>> do mixing.
> 
> Slight correction/expansion -- don't do _software_ mixing. Some cards 
> can do hardware mixing and in that case, "hw:N" or, specifically 
> "hw:N,0", "hw:N,1" and so on devices are available as hardware mixed 
> devices.

Correcting the correction (sorry, it was late) -- "hw:N" is card N, "hw:N,M" 
is PCM interface M of card N and "hw:N,M,K" is (hardware mixed) subdevice K 
on PCM interface M of card N. Normal cards have only one PCM interface 
meaning that M is 0 in the above.

That is, I meant that "hw:N,0,0", "hw:N,0,1" and so on are the hardware 
mixed devices.

Rene.
