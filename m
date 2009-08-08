Return-Path: <linux-kernel-owner+w=401wt.eu-S932957AbZHHDJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932957AbZHHDJl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 23:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932892AbZHHDJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 23:09:40 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:45715 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932868AbZHHDJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 23:09:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=WaSm9J1rMEkILuwJXHrYJiEXT1VmLIpq9NojQ75Q5jo70jfw7YpSzuk9KX/ETNxjpd
         V+ynkUYxEOIjLiM9rfuJwDwe1nnyWwqciNmKB4Ubko7F3BHZ1BoRQqE3yL1Ixzabi6gq
         wvhXGkom2KkoYLVXXzyDnHE4ONtwxxQnZmfSw=
Message-ID: <4A7CEC70.4050806@gmail.com>
Date: Fri, 07 Aug 2009 21:09:36 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make shr to divide by power of 2
References: <20090806180930.GA3004@localdomain.by> <87d478i0d7.fsf@basil.nowhere.org>
In-Reply-To: <87d478i0d7.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2009 12:50 AM, Andi Kleen wrote:
> Sergey Senozhatsky<sergey.senozhatsky@gmail.com>  writes:
>> Of course, compiler supposed to do something like
>> 	add    $0x7,%eax
>> 	shr    $0x3,%eax
>> instead of div. Should we rely on this?
>
> Yes. We should rely on this.

It may depend on the selected CPU type that gcc is optimizing for - I 
believe that on some P4s the shift may actually be slower than the divide..
