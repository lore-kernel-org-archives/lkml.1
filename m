Return-Path: <linux-kernel-owner+w=401wt.eu-S1753436AbYLODkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbYLODkB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 22:40:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbYLODju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 22:39:50 -0500
Received: from rv-out-0506.google.com ([209.85.198.239]:55821 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbYLODjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 22:39:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=v7KIXqjcyZy0Keir5vz5Ukt++M9ozFNSMHhHcsql6k10Qsxg2wac23Su1S8037dtCA
         DuEWwRKdJTX/kwCkavis4GOfyBT1mxjLzxXfKIW40Ux/esgSF4C2AK+RoMV4Y3LFJuKr
         7tpIp0jghjeT3aPZ1cgVgFifSj2nldoIpWCYI=
Message-ID: <86802c440812141939s2fe0fd9g5f9899ed9e4f6e6c@mail.gmail.com>
Date: Sun, 14 Dec 2008 19:39:48 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] add command line init_start_cpus
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <87myeyfgb7.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4944A279.5020009@kernel.org> <87myeyfgb7.fsf@basil.nowhere.org>
X-Google-Sender-Auth: f467a1869d126f25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2008 at 4:11 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Yinghai Lu <yinghai@kernel.org> writes:
>
>> Impact: new command line
>>
>> so could select cpus to be started during init stage
>
> maxcpus=N should do this already, at least for the first N cpus.
> If you really need a non continuous range of N (why?) then it would
> be better to fix maxcpus instead of adding a new option.

it seems it is hard to make maxcpus= to support random cpus selecting and
maxcpus=0 looks insane

also maxcpus=1, will disable smp, can you enable other cpus later in user space?

YH
