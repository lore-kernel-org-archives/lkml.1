Return-Path: <linux-kernel-owner+w=401wt.eu-S1757896AbZFRCoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896AbZFRCoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 22:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752753AbZFRCoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 22:44:13 -0400
Received: from smtp-out.google.com ([216.239.45.13]:47071 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbZFRCoM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 22:44:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=RqaLbtgpw8YAp8G25jlxbftNyZTPdnJRiNlJadi/YZm5J6yGZ7ctYfL3qdFDl6D+J
	gGGNxm3kT4ndjEQ+L5m1Q==
MIME-Version: 1.0
In-Reply-To: <49b7c2350906171856n4f7f7ca8u5f5302be2b4ae8a9@mail.gmail.com>
References: <1245285075-20022-1-git-send-email-swetland@google.com>
	 <1245285075-20022-2-git-send-email-swetland@google.com>
	 <1245285075-20022-3-git-send-email-swetland@google.com>
	 <1245285075-20022-4-git-send-email-swetland@google.com>
	 <49b7c2350906171856n4f7f7ca8u5f5302be2b4ae8a9@mail.gmail.com>
Date: Wed, 17 Jun 2009 19:44:11 -0700
Message-ID: <a55d774e0906171944x7d96c20dhb5c29e8ce2c6772b@mail.gmail.com>
Subject: Re: [PATCH 3/3] [ARM] msm: add minimal board file for HTC Dream 
	device
From: Brian Swetland <swetland@google.com>
To: GeunSik Lim <leemgs1@gmail.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       pavel@ucw.cz
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 6:56 PM, GeunSik Lim<leemgs1@gmail.com> wrote:
> On Thu, Jun 18, 2009 at 9:31 AM, Brian Swetland<swetland@google.com> wrote:
>> This is just enough to get the device booting and serial console
>> working.  Sufficient for debugging further MSM7k/Dream Support.
>> This will support HTC Dream / T-Mobile G1 / Android ADP1 (which
>> are all the same hardware, known as "trout" to the ARM machine
>> database).
> Hi Brian,
> I have one silly question.
> I still not understand "trout" meaning with your description.
>
>> +config MACH_TROUT
>> +       default y
>> +       bool "HTC Dream (aka trout)"
>> +       help
>> +         Support for the HTC Dream, T-Mobile G1, Android ADP1 devices.
>> +
> "trout" word just means HTC Dream Model. Is it right?

Yes -- this is the ARM linux kernel machine ID for this hardware:
http://www.arm.linux.org.uk/developer/machines/list.php?id=1440

Brian
