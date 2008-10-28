Return-Path: <linux-kernel-owner+w=401wt.eu-S1753721AbYJ1NvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721AbYJ1NvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 09:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752616AbYJ1NvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 09:51:10 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:17803 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbYJ1NvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 09:51:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=sq2H2yZKMZa+DMWeODmuQX5J8pfgHrAydCZyvU+SszJ3y+5fNkOFC73s7+f5xYpkoR
         Tz/nfKGlfuZ+a9qsoTU3P2t1P6BQV7n+L6dRIp+a1FivJV0GkMizTVYJKVnNFeRiknNP
         2faAaSi2gqceOGGh92DtDHv6ZlGQBFvrQz/34=
Message-ID: <490718C7.3010501@gmail.com>
Date: Tue, 28 Oct 2008 14:51:03 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Francois Romieu <romieu@fr.zoreil.com>, Simon Arlott <simon@fire.lp0.eu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>, Edward Hsu <edward_hsu@realtek.com.tw>,
       Ivan Vecera <ivecera@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: r8169 MAC addresses broken
References: <490380C8.6070003@simon.arlott.org.uk>	<4903947A.3060206@gmail.com>	<20081025223443.GA30913@electric-eye.fr.zoreil.com>	<4904A7C5.7090801@gmail.com>	<20081026174654.GB24790@electric-eye.fr.zoreil.com>	<4906E4BE.9050304@gmail.com> <m3mygozvd4.fsf@maximus.localdomain>
In-Reply-To: <m3mygozvd4.fsf@maximus.localdomain>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2008 02:45 PM, Krzysztof Halasa wrote:
> Jiri Slaby <jirislaby@gmail.com> writes:
> 
>>> Same thing if you unplug the battery ?
>> Thanks, now it seems to be OK.
> 
> Well, perhaps reverting that patch was a bit premature?

No, it helped after reverting that patch. I think we don't want defunct 2.6.28
with these nics.

> If removing battery fixes the problem then it's not the EEPROM.

Agreed.
