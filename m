Return-Path: <linux-kernel-owner+w=401wt.eu-S932112AbZAWSm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112AbZAWSm7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 13:42:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754121AbZAWSmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 13:42:51 -0500
Received: from smtp-out.google.com ([216.239.33.17]:52055 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593AbZAWSmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 13:42:50 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=XG9wJbB6V3Bb1W0eXZachSA6eEfx6aKGhdfdNVMvQg829pxn2+pa72Q4Y+zhwdbcw
	ST3Bz9FlNlrNjhlukHGiw==
MIME-Version: 1.0
In-Reply-To: <20090123183653.GC5984@elte.hu>
References: <20090123004703.25103.29754.stgit@menage.corp.google.com>
	 <20090123181056.GA31142@elte.hu>
	 <6599ad830901231032h76a301ceica371145eca30388@mail.gmail.com>
	 <20090123183653.GC5984@elte.hu>
Date: Fri, 23 Jan 2009 10:42:44 -0800
Message-ID: <6599ad830901231042w69555fdfi5a033c0856a55824@mail.gmail.com>
Subject: Re: [PATCH] cgroup: Fix root_count when mount fails due to busy 
	subsystem
From: Paul Menage <menage@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org, serue@us.ibm.com, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.25.146.18
X-GMailtapped: menage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2009 at 10:36 AM, Ingo Molnar <mingo@elte.hu> wrote:
>>
>> It's via the call to deactivate_super().
>
> Which exact call chain is that?

cgroup_get_sb() -> *failure* -> deactivate_super() -> VFS stuff
(sorry, no access to a source tree right now) -> cgroup_kill_sb()

Paul
