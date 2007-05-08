Return-Path: <linux-kernel-owner+w=401wt.eu-S966939AbXEHRet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966939AbXEHRet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 13:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965655AbXEHRep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 13:34:45 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:6340 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934518AbXEHReo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 13:34:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KK8cW/5Ad40K1HkQuXU5TsVa/KG2nMQImocjO45Mi+UsX0bselGig74xeYmidFqOpDgJlWs/5G1QmADBDYju4eLrqoHyVIrxufFpLKUGn0xJUmtRked9arFbgVPOUJMwpLoCKZ9cXqlUwz1+66ZML/50ENGCsvOPDQVVl9FF8NY=
Message-ID: <86802c440705081034p63b598faqdf1205fdae02f86f@mail.gmail.com>
Date: Tue, 8 May 2007 10:34:42 -0700
From: yhlu <yhlu.kernel@gmail.com>
To: vgoyal@in.ibm.com
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for relocatable bzImage
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Gerd Hoffmann" <kraxel@redhat.com>, "Jeff Garzik" <jeff@garzik.org>,
       patches@x86-64.org, linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>
In-Reply-To: <20070508172449.GA1932@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46385A8A.6070405@redhat.com> <4638F9BE.8090508@zytor.com>
	 <4638FC39.4010101@goop.org> <4638FE1B.9050901@zytor.com>
	 <46390523.5010809@goop.org> <463909AF.9040205@zytor.com>
	 <20070503045031.GA5794@in.ibm.com>
	 <m1tzuuv24z.fsf@ebiederm.dsl.xmission.com>
	 <86802c440705080941y69ddd5d6lab170c5f3967f148@mail.gmail.com>
	 <20070508172449.GA1932@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/8/07, Vivek Goyal <vgoyal@in.ibm.com> wrote:
> setup.S is never executed while doing kexec (unless somebody chooses to
> do a real mode entry) and these patches don't change this beahviour.
>
> Tomorrow I will test VGA behaviour on my machine. Are you using some
> special frame buffer mode etc?
>

I disabled the FB in the kernel.

YH
