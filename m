Return-Path: <linux-kernel-owner+w=401wt.eu-S1759348AbYA1LI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759348AbYA1LI4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 06:08:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751227AbYA1LIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 06:08:49 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:52026
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbYA1LIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 06:08:48 -0500
Message-ID: <479DB7BE.4040106@qumranet.com>
Date: Mon, 28 Jan 2008 13:08:46 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH][RFC] SVM: Add Support for Nested Paging in
 AMD Fam16 CPUs
References: <1201294393-22613-1-git-send-email-joerg.roedel@amd.com>	<479C4763.1080104@qumranet.com> <479D4A0C.5080208@goop.org>
In-Reply-To: <479D4A0C.5080208@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Avi Kivity wrote:
>   
>>  I find it non-descriptive, and it reminds me of another hypervisor.  
>> I suggest 'tlp' for two-level paging.
>>     
>
> That has its own ambiguity; without other context it reads like 
> "two-level pagetable".  Anyway, using the same term for the same thing 
> is not a bad idea.
>
>   

What annoys me about hap and hvm is that it comes from a 
paravirtualization viewpoint, where pv is the default model, and 
hardware extensions are an optional addition.  With kvm it's the other 
way round: the base model is full virtualization, and paravirtualization 
is an optional add-on.  I'd rather call traditional shadow paging 
"software-assisted paging".


-- 
error compiling committee.c: too many arguments to function

