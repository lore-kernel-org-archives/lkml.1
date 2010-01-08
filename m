Return-Path: <linux-kernel-owner+w=401wt.eu-S1753878Ab0AHTbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab0AHTbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 14:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540Ab0AHTbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 14:31:17 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:38501 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab0AHTbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 14:31:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=t3McP4Bs+fbngyRbfj1abWjvkNM2JDyg/iZbIJxwqnCv9rc1/eTshuaoGe0M+hSBY+
         rMrBoNnBfhu7lDT8JwumHy2g6CDbLho+bWHk1TBqi6C+BFhLSJ0NR0NixKuZ3gHy9dD2
         kP0DYOjXX/TbrsveJrjH973tr4gKDIpesyjk0=
MIME-Version: 1.0
In-Reply-To: <4B478689.5020907@redhat.com>
References: <1262700774-1808-1-git-send-email-gleb@redhat.com> 
	<20100108161828.GA30404@amt.cnet> <4B478689.5020907@redhat.com>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Fri, 8 Jan 2010 14:30:55 -0500
Message-ID: <3e8340491001081130v2adb8e07k3b32f7f860daf603@mail.gmail.com>
Subject: Re: [PATCH v3 00/12] KVM: Add host swap event notifications for PV 
	guest
To: Rik van Riel <riel@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       avi@redhat.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, hpa@zytor.com, cl@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 8, 2010 at 2:24 PM, Rik van Riel <riel@redhat.com> wrote:
> On 01/08/2010 11:18 AM, Marcelo Tosatti wrote:
>
>> - Limit the number of queued async pf's per guest ?
>
> This is automatically limited to the number of processes
> running in a guest :)

Only if the guest is nice and plays by the rules. What is to stop a
malicious guest from just immediately switching back to userspace and
kicking off another page-in every time it gets an async PF?
