Return-Path: <linux-kernel-owner+w=401wt.eu-S1756571AbYFCGHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571AbYFCGHu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 02:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753009AbYFCGHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 02:07:42 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57997 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbYFCGHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 02:07:42 -0400
From: "Takashi Nishiie" <t-nishiie@np.css.fujitsu.com>
To: "'Mathieu Desnoyers'" <mathieu.desnoyers@polymtl.ca>,
       "'Peter Zijlstra'" <peterz@infradead.org>
Cc: "'Hideo AOKI'" <haoki@redhat.com>, <mingo@elte.hu>,
       "'Masami Hiramatsu'" <mhiramat@redhat.com>,
       <linux-kernel@vger.kernel.org>
References: <48447052.3030300@redhat.com> <1212445965.6269.22.camel@lappy.programming.kicks-ass.net> <20080602232135.GA20173@Krystal>
In-Reply-To: <20080602232135.GA20173@Krystal>
Subject: RE: Kernel marker has no performance impact on ia64.
Date: Tue, 3 Jun 2008 15:07:48 +0900
Message-ID: <002c01c8c540$25c0cbb0$71426310$@css.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcjFB3NOmh6lhxDcTt6h0zF7U0+fEwAODRLQ
Content-Language: ja
x-cr-hashedpuzzle: Agjq BCD8 FB+W J37M MOFE QLkX Zu8f cBuJ mtZc r9ie yTKF 0JjX 3iOy 4LX6 95/Z AANdjQ==;6;aABhAG8AawBpAEAAcgBlAGQAaABhAHQALgBjAG8AbQA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBtAGEAdABoAGkAZQB1AC4AZABlAHMAbgBvAHkAZQByAHMAQABwAG8AbAB5AG0AdABsAC4AYwBhADsAbQBoAGkAcgBhAG0AYQB0AEAAcgBlAGQAaABhAHQALgBjAG8AbQA7AG0AaQBuAGcAbwBAAGUAbAB0AGUALgBoAHUAOwBwAGUAdABlAHIAegBAAGkAbgBmAHIAYQBkAGUAYQBkAC4AbwByAGcA;Sosha1_v1;7;{19758E1C-9F4C-42CE-B7DF-C584D9A17998};dAAtAG4AaQBzAGgAaQBpAGUAQABuAHAALgBjAHMAcwAuAGYAdQBqAGkAdABzAHUALgBjAG8AbQA=;Tue, 03 Jun 2008 06:07:08 GMT;UgBFADoAIABLAGUAcgBuAGUAbAAgAG0AYQByAGsAZQByACAAaABhAHMAIABuAG8AIABwAGUAcgBmAG8AcgBtAGEAbgBjAGUAIABpAG0AcABhAGMAdAAgAG8AbgAgAGkAYQA2ADQALgA=
x-cr-puzzleid: {19758E1C-9F4C-42CE-B7DF-C584D9A17998}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

> One of my goal is to provide a mechanism that can feed both non-debug
> and debug information to a generic tracing mechanism to allow
> system-wide analysis of the kernel, both for production system and
> kernel debugging.

 I agree with the target.
 I understand there is a person who is the neat paranoiac that it 
doesn't want to leave the code for debugging for a final code. If 
it is a situation in which the code for debugging without united 
interfaces lies scattered, the opinion might be correct. 
 It is an effective method only to set up the marker if the code 
for debugging without united interfaces can be appropriately set 
up with the marker. 
 I think that the mechanism that can offer both non-debugging and
debugging information to the generic pursuit mechanism to permit 
the analysis of the entire kernel system in the meaning of 
obtaining dynamic information for a long time not obtained by a 
static necropsy by kdump is indispensable in a mission-critical 
system.

Regards.



