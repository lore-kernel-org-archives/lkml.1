Return-Path: <linux-kernel-owner+w=401wt.eu-S1758461AbZA2OQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758461AbZA2OQt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 09:16:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753068AbZA2OQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 09:16:40 -0500
Received: from rv-out-0506.google.com ([209.85.198.236]:1233 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbZA2OQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 09:16:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mqaaDwimYO+WE3UmL5PmQNx2RItv5JdJBT10X+QtLLDNqxBGajvh97uDL582DxRlZ4
         HVEVSsqiC/vpPdtCF4PyCvZPFVKiLNLriQWVK8N6kxgIFyjCyVwYxxTyKhOm/uuS3OJr
         I43vSf4k81DXmGoDNVlFSeurSLbxo4/BGidh0=
MIME-Version: 1.0
In-Reply-To: <20090129134537.12121834@lxorguk.ukuu.org.uk>
References: <1a26b4920901290302w5c9bb79cra29fda5e67cc96a4@mail.gmail.com>
	 <20090129134537.12121834@lxorguk.ukuu.org.uk>
Date: Thu, 29 Jan 2009 15:16:39 +0100
Message-ID: <1a26b4920901290616r40c1edd0tec62d0e6bf24dc9@mail.gmail.com>
Subject: Re: NEWBIE: how to change serial device<->port association
From: Pazzo Da Legare <pazzodalegare@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Alan,

Thank you very much for your help.
I'm going to have a look at the table you mentioned. Yes, I know that
usually one should make the selection from application, in my case I'm
trying to uniform two different hardware maintaining  the
configuration for applications (running on both).

The hws have a different combination of kind serials and I would like
to present the same ttyS* to applications. I need to have different
kernel configuration so I thought I could uniform things there....I'm
going to evaluate the hardness


p

2009/1/29 Alan Cox <alan@lxorguk.ukuu.org.uk>:
> On Thu, 29 Jan 2009 12:02:49 +0100
> Pazzo Da Legare <pazzodalegare@gmail.com> wrote:
>
>> Dear ML,
>>
>> how can I instruct the kernel (if possible) to map a certain serial
>> port to a specific device ttySx?
>
> The kernel mapping defaults are from a table so you could recompile
> the kernel. However applications should always let you select a serial
> port.
>
> Alan
>
