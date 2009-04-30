Return-Path: <linux-kernel-owner+w=401wt.eu-S1761745AbZD3B6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761745AbZD3B6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 21:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752374AbZD3B6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 21:58:14 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:56943 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbZD3B6N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 21:58:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BaiL0lHs3P0qHb7Tp3WInPDc17u3wqpYN6Ufk2wJFLw3Fa8wBptuXjTxan2mQTTo/N
         TCUq3F7NYY9AItRf1IuWoQEjBTiY6IF92AeOGJgQm3IR/+VR96TYJr5fIX4tVX2ehz0b
         6mGDXma4t4v3Xxg1AE4EyuDG2DOrmM5nXW7Kg=
MIME-Version: 1.0
In-Reply-To: <ac3eb2510904291854v6f669b80l56f66fb230ae3e2c@mail.gmail.com>
References: <20090427193532.GA2948@kroah.com>
	 <8bd0f97a0904291053g3aa71decpd33f6621ad0bf9f8@mail.gmail.com>
	 <20090429180735.GA29812@kroah.com>
	 <8bd0f97a0904291117ic07fadcs2a02fca3dcfefcf0@mail.gmail.com>
	 <20090429183012.GA28237@kroah.com>
	 <8bd0f97a0904291638p398ad701j5dc0f8e96de2fb47@mail.gmail.com>
	 <ac3eb2510904291745j48220c12oe2a2b91e981ea403@mail.gmail.com>
	 <8bd0f97a0904291848le808891kff973b1677b7cd33@mail.gmail.com>
	 <ac3eb2510904291854v6f669b80l56f66fb230ae3e2c@mail.gmail.com>
Date: Wed, 29 Apr 2009 21:58:12 -0400
Message-ID: <8bd0f97a0904291858s1c3550b5xe9ec3e1b291d8547@mail.gmail.com>
Subject: Re: usbutils 0.81 release
From: Mike Frysinger <vapier.adi@gmail.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 21:54, Kay Sievers wrote:
> On Thu, Apr 30, 2009 at 03:48, Mike Frysinger wrote:
>> On Wed, Apr 29, 2009 at 20:45, Kay Sievers wrote:
>>> On Thu, Apr 30, 2009 at 01:38, Mike Frysinger wrote:
>>>> guess i'll have to rewrite it to parse the .ko modules directly like
>>>> the usbmap is generated now
>>>
>>> Can't you use the modules.aliases file? That should stay around and
>>> there should be the same information contained.
>>
>> should be fine if it's going to be sticking around
>>
>> any comments on the attached file ?  in theory, it could be easily
>> extended for pci and other busses ...
>
> Hmm, you still use the map files? I meant if you could use:
>  /lib/modules/$(uname -r)/modules.alias

yes, i got what you mean, i just forgot to update the map= setting.  i
updated the important part (the awk parsing) so that it uses the
modules.alias format.

if the rest is fine i can send a git patch along to the usb lists.
-mike
