Return-Path: <linux-kernel-owner+w=401wt.eu-S1763246AbZDBTgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763246AbZDBTgs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 15:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550AbZDBTgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 15:36:31 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:34894 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbZDBTgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 15:36:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=spuDZVjgqgTOxUoIn9ePGjITww8ENcdsbVptoPeGAgRtIEiJG6Ok45q7bxTeU31mpY
         HJt6WTU2AzRS5OII8YGmVwwvEcZG+hKSphSyPmpe716rOKRgtZ1tPFXsB7/gz/mQbDXr
         r+P6V/ZzKaAvSMW9GxBkkZzeSMF053vkhqrXA=
MIME-Version: 1.0
In-Reply-To: <6c62e9d84a16902aebba9438b4e299d9.squirrel@localhost>
References: <159a870e0904020702q3c528b8u77cebf834d607e3f@mail.gmail.com>
	 <6c62e9d84a16902aebba9438b4e299d9.squirrel@localhost>
Date: Thu, 2 Apr 2009 16:36:28 -0300
Message-ID: <159a870e0904021236m6ef4444eh66ec42e34aa24291@mail.gmail.com>
Subject: Re: RAID performance / tuning?
From: Tiago Freire <tiago.freire@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I would like to believe this is not the case with Intel ICH9R...

Anyway, I want to make sure I have done everything possible to speed
up my 6-disk RAID.
Scheduling concurernt IO may not have a best single solution, I know,
but is the kernel 'perfect' in the sense of giving the RAID / SATA
subsystems all the cpu cycles it needs to perform best (with the
lowest possible latency)? Or do we have some knobs to tune the kernel?


On Thu, Apr 2, 2009 at 2:41 PM,  <david.hagood@gmail.com> wrote:
>
>> Why is it that software RAID on current systems still gets less
>> performance than hardware counterparts?
>
> Part of it can be crappy disk interfaces: I was running software raid with
> 2 SATA-SIL cards, and would frequently be disk-bound with the CPU still
> largely idle.
>
> The cards were incapable of talking to more than one drive at a time. They
> didn't support command queuing on the drives.
>
> As a result, the system would set up a stripe, queue up the writes, then
> have to wait as each write for EACH DISK in the 7 disk array was carried
> out.
>
> On a good hardware RAID controller, the disks can be written in parallel,
> and the controller will support command queuing - so disk writes can be
> run in parallel, and the writes themselves can be better optimized by the
> disks.
>
>
>



-- 
-----
Tiago Mikhael Pastorello Freire a.k.a. Brazilian Joe
