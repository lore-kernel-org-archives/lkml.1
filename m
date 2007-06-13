Return-Path: <linux-kernel-owner+w=401wt.eu-S1759085AbXFMPRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759085AbXFMPRj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 11:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757738AbXFMPRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 11:17:32 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:34350 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758010AbXFMPRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 11:17:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=c4W0G9OBFYGiuwZaFZN2IpAHzlZn+Vu7AqeXVoCvVC8JLmW2F7IUe6i2T7EZfpZitkjCnmWfa9WHYWMWY7W9i3jdz1KweWOb3RrPH/238yG3hsPF2OqzrCWh5w/UdFY6Hc1YsmtPYT/d4J6QPRXLRDpQli65v6Xlcjt1EEQpYMU=
Message-ID: <d120d5000706130817v5b9291d4h8653ade63882d2bc@mail.gmail.com>
Date: Wed, 13 Jun 2007 11:17:30 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Jiri Kosina" <jikos@jikos.cz>
Subject: Re: USB remote control missing keycodes
Cc: "Islam Amer" <pharon@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0706131654180.23280@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070611101319.GA14284@DervishD> <466D2DF7.9020709@aladin.ro>
	 <1181563063.19258.11.camel@iamer-laptop>
	 <Pine.LNX.4.64.0706111656340.23280@twin.jikos.cz>
	 <1181743734.6163.1.camel@iamer-laptop>
	 <Pine.LNX.4.64.0706131654180.23280@twin.jikos.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/13/07, Jiri Kosina <jikos@jikos.cz> wrote:
> On Wed, 13 Jun 2007, Islam Amer wrote:
>
> > back ( not working )
> > [  829.897373] drivers/hid/hid-core.c: report (size 5) (numbered)
> > [  829.897380] drivers/hid/hid-core.c: report 4 (size 4) =  fa 00 00 00
> > [  829.897389] hid-debug: input Consumer.0000 = 0
> [...]
> > txt ( not working )
> > [  900.156751] drivers/hid/hid-core.c: report (size 5) (numbered)
> > [  900.156762] drivers/hid/hid-core.c: report 5 (size 4) =  5a 00 00 00
> > [  900.156771] hid-debug: input ffbc.0000 = 0
> > [  900.156781] hid-debug: input ffbc.005a = 1
>
> Oh my, another 'creative' vendor :( We really desperately need the
> hidbus, so that we could handle those misbehaving vendors in cleaner
> way, I am constantly moving that up in my todo :)
>

Actually this one does not need hidbus and can be easily handled from
userspace now that we have setkeycodes support for HID.

-- 
Dmitry
