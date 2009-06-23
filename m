Return-Path: <linux-kernel-owner+w=401wt.eu-S1755037AbZFWGkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037AbZFWGkh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 02:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbZFWGk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 02:40:27 -0400
Received: from mail-fx0-f224.google.com ([209.85.220.224]:48447 "EHLO
	mail-fx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbZFWGkY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 02:40:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bpDQQkIlYHeHa1p4qrQQaWkAHmfkFN6GElG7VA9dhCkjUWld1pb0WbiCePVIYjc16F
         lrZKqVftn9iG/kWwcY7N7ynLfCJkmm3TshUZf+ip/t+KA+yjBZgtbjto3HuEtLQ60234
         2KrAhZL6hO6omnrgl3qrF3VCak3skZghE0fZE=
MIME-Version: 1.0
In-Reply-To: <200906222033.20883.arnd@arndb.de>
References: <4A33A7EC.6070008@gmail.com> <200906221317.04166.arnd@arndb.de>
	 <4A3FC7F1.5050108@gmail.com> <200906222033.20883.arnd@arndb.de>
Date: Tue, 23 Jun 2009 08:40:25 +0200
Message-ID: <2ea1731b0906222340o13e9cf0fu7e15cddadf27bbbb@mail.gmail.com>
Subject: Re: [PATCH 06/14] Pramfs: Include files
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/22 Arnd Bergmann <arnd@arndb.de>:
> On Monday 22 June 2009, Marco wrote:
>>
>> Sorry, I meant it's not currently possible. At the moment the only way
>> to use it as rootfs it's to copy all the data in an already mounted
>> (empty) ram partition and reboot. However it's not my first item on my
>> todo list because I think that it's possible to use it as rootfs but it
>> isn't the standard use for this fs.
>
> Well, it doesn't have to work right away. What I'm asking to
> define the data structures in a way that keeps the layout stable
> across kernel updates. Since a future version of the file system
> might support cross-endian image creation, it would be good to
> define the data structures in a fixed endian mode already, so
> you don't have to change it in the future.
>
>        Arnd <><
>

I was refering to create a tool "mkpramfs".

Marco
