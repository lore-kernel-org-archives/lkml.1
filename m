Return-Path: <linux-kernel-owner+w=401wt.eu-S1758029AbZIFQLH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029AbZIFQLH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 12:11:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757980AbZIFQLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 12:11:06 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:11578 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757970AbZIFQLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 12:11:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=xe3R0tTElnw11b4r6fhIAZi+/KHZ3Mblf8UuFpKpg7rf0pPZaraCST56TdPdD1jW0z
         wPyn98WOViMMbL/CwyIN4L72eXM5wdIdpA0qNrXmmp1MQhukdl8lHpzY6tvji0AxfZtv
         Aw5QoOpDX/9I/VQ4T/xqx564gQtjeRKZH7nyg=
Message-ID: <4AA3DF17.2000401@gmail.com>
Date: Sun, 06 Sep 2009 18:11:03 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.1) Gecko/20090715 SUSE/3.0b3-8.5 Thunderbird/3.0b3
MIME-Version: 1.0
To: Trond Myklebust <Trond.Myklebust@netapp.com>
CC: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-nfs@vger.kernel.org
Subject: Re: mount.nfs oops [was: mmotm 2009-09-03-16-35 uploaded]
References: <200909032340.n83Ne6E6004708@imap1.linux-foundation.org>	 <4AA17E74.8060100@gmail.com>	 <1252102337.5274.4.camel@heimdal.trondhjem.org>	 <4AA19420.5060503@gmail.com> <1252104797.5274.19.camel@heimdal.trondhjem.org>
In-Reply-To: <1252104797.5274.19.camel@heimdal.trondhjem.org>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2009 12:53 AM, Trond Myklebust wrote:
> On Sat, 2009-09-05 at 00:26 +0200, Jiri Slaby wrote:
>> On 09/05/2009 12:12 AM, Trond Myklebust wrote:
>>> Also, were you doing anything special at the time (for instance removing
>>> a module)?
>>
>> Not at all. I just did
>> # mount /work
>> # grep work /etc/fstab
>> XXX.YYY.ZZZ:/work     /work           nfs     defaults,intr   0 0
>>
> Hmm... Is it fully reproducible? I'm running the same NFS client code
> (although not the full linux-mm) on several different client platforms
> without seeing any issues.

I saw this only twice on the same bootup. I can't reproduce on demand,
sorry.
