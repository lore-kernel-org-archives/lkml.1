Return-Path: <linux-kernel-owner+w=401wt.eu-S1752521AbZJZPGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbZJZPGj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 11:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbZJZPGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 11:06:38 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:58046 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbZJZPGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 11:06:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:from:date:x-google-sender-auth:message-id
         :subject:to:content-type;
        b=AlH6jJ5F1Q6ym8wVb1LVs7ImiIlZFsf40HPyk3zSJV0FKehw0xQKieUkYFPNAY/b65
         clIlJdV5mrtgjjMrM8GV6iaXOnk5k1Dc+4a0v4NVwDg8o3HqqDB8HbrR4Mgq++W+4lWR
         ZhCGSxDVnQuliVOziGyWdDbHnccLJ5OhdOSN4=
MIME-Version: 1.0
From: pradeep hettiarachchi <pradeepmh@wayne.edu>
Date: Mon, 26 Oct 2009 11:06:23 -0400
X-Google-Sender-Auth: ccde98d79d23280b
Message-ID: <8fe204b0910260806l10896f9foc0568dd0b8f4b6ca@mail.gmail.com>
Subject: Frequency Scaling on Intel Core 2 Duo Processors
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am working on a research in real-time systems. If I want to change
the frequency of the system as rapidly as possible, what is the best
method ? At the moment I write MSR_IA32_PERF_CTL, MSR directly with
the pre-found(calculated, encoded) values** for different frequencies.
I found the entire transition (latency) takes multiple milliseconds to
complete; however, I want some faster method to change the CPU
frequency.
Thank you in advance.


-Pradeep

** Initially I change the CPU frequency by some other method, such as
methods provided by an available user-space governor, and record the
MSR_IA32_PERF_STATUS values corresponding to that frequency. Later, I
change the relevant bits of MSR_IA32_PERF_CTL, with the values I got
previously, to achieve the relevant anticipated speed.
