Return-Path: <linux-kernel-owner+w=401wt.eu-S1756112AbZDNRdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112AbZDNRdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 13:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753220AbZDNRdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 13:33:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36406 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbZDNRdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 13:33:20 -0400
Message-ID: <49E4C8C8.9060109@zytor.com>
Date: Tue, 14 Apr 2009 10:32:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Avi Kivity <avi@redhat.com>, Glauber Costa <glommer@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] deal with interrupt shadow state for emulated instruction
References: <1239653210-10422-1-git-send-email-glommer@redhat.com>	<49E45894.7090700@redhat.com>	<49E4B4D4.1020903@zytor.com>	<49E4B654.6060101@redhat.com> <20090414183111.0243408e@lxorguk.ukuu.org.uk>
In-Reply-To: <20090414183111.0243408e@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> Why?  Do you see a guest filling all of memory with 'mov ss' and 
>> expecting to break out of it via an interrupt?
> 
> Well I did try mapping a page of move ss all through memory on real
> hardware long ago and seeing what happened on a 386 in real mode with
> DOSEMU. I was disappointed ;)
> 

Heheheheh....

	-hpa
