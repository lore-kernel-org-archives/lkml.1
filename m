Return-Path: <linux-kernel-owner+w=401wt.eu-S932125AbXLTVXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125AbXLTVXw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 16:23:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761872AbXLTVXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 16:23:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34490 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757568AbXLTVXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 16:23:06 -0500
Message-ID: <476ADBB6.6040003@zytor.com>
Date: Thu, 20 Dec 2007 13:16:38 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Glauber de Oliveira Costa <gcosta@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       ak@suse.de, chrisw@sous-sol.org, rostedt@goodmis.org, zach@vmware.com,
       roland@redhat.com
Subject: Re: [PATCH 15/15] replace x86_read/write_per_cpu with a common function.
References: <11981810504172-git-send-email-gcosta@redhat.com> <11981811293763-git-send-email-gcosta@redhat.com> <11981811852758-git-send-email-gcosta@redhat.com> <11981812041672-git-send-email-gcosta@redhat.com> <1198181215625-git-send-email-gcosta@redhat.com> <1198181224677-git-send-email-gcosta@redhat.com> <11981812412879-git-send-email-gcosta@redhat.com> <11981812771615-git-send-email-gcosta@redhat.com> <1198181309285-git-send-email-gcosta@redhat.com> <11981813192341-git-send-email-gcosta@redhat.com> <11981813292926-git-send-email-gcosta@redhat.com> <11981813384090-git-send-email-gcosta@redhat.com> <1198181348746-git-send-email-gcosta@redhat.com> <11981813592589-git-send-email-gcosta@redhat.com> <11981813691362-git-send-email-gcosta@redhat.com> <11981813802836-git-send-email-gcosta@redhat.com>
In-Reply-To: <11981813802836-git-send-email-gcosta@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber de Oliveira Costa wrote:
> x86_read_per_cpu() and its writeish sister are not present in x86_64. So in
> this patch, we replace them with __get_cpu_var(), which is present in both

Eventually we'd like to use something closer to the i386 code for 
x86_64, obviously...

	-hpa
