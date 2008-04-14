Return-Path: <linux-kernel-owner+w=401wt.eu-S934334AbYDNSnE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934334AbYDNSnE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:43:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933391AbYDNSmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:42:07 -0400
Received: from relay2.sgi.com ([192.48.171.30]:34174 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933206AbYDNSmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:42:05 -0400
Date: Mon, 14 Apr 2008 13:42:03 -0500
From: Paul Jackson <pj@sgi.com>
To: Max Krasnyanskiy <maxk@qualcomm.com>
Cc: menage@google.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org
Subject: Re: boot cgroup questions
Message-Id: <20080414134203.ea5a7de7.pj@sgi.com>
In-Reply-To: <47FE5655.10900@qualcomm.com>
References: <47D73086.2030008@qualcomm.com>
	<6599ad830803111827n1cb8e2c7i47c2ef3f3bb58995@mail.gmail.com>
	<47D7411E.1000009@qualcomm.com>
	<6599ad830803111936jd940deam8584bc971c3b6f41@mail.gmail.com>
	<47D74595.4080100@qualcomm.com>
	<6599ad830803112009y18d9e43ft8e3fc4a551d891da@mail.gmail.com>
	<20080311235939.1ebee8e3.pj@sgi.com>
	<47D81FE1.6030205@qualcomm.com>
	<20080312135746.89456f2a.pj@sgi.com>
	<47D82AD2.1070108@qualcomm.com>
	<20080312143253.3dd72c7f.pj@sgi.com>
	<47D83858.4030806@qualcomm.com>
	<20080312153712.bc5df7a1.pj@sgi.com>
	<47D8593A.6040503@qualcomm.com>
	<20080312183059.6716d630.pj@sgi.com>
	<47D87BE5.4010702@qualcomm.com>
	<20080313020300.92244956.pj@sgi.com>
	<47FE5655.10900@qualcomm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max K wrote:
> I agree in general. In this particular case additional grouping introduces 
> even more hierarchy. I seems to me that
> 	"irqN -> cpu1, cpu2, cpu3"
> is a very simple, straightforward relationship. Whereas
> 	"irqN -> groupX"
> 	"groupX -> cpu1"
> 	"groupX -> cpu2"
> 	"groupX -> cpu3"
> Is not that straightforward.

Clearly, yes, the first is simpler than the second.

The question is which is correct.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
