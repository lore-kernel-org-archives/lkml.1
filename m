Return-Path: <linux-kernel-owner+w=401wt.eu-S1758266AbYJVRu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266AbYJVRu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759520AbYJVRob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:44:31 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:41884 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759512AbYJVRo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:44:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=oDcuVyzYmrb57YByBmyCTl0HRNqh+upVdaSpBKsqOFrOF1CY4mUqOtA2hBLzsunJB3
         YmB/fSpBuK59byITQKRDyG+JrgPc99GTV0iYdbLToE7A1ZkEA2JqY9OMgfONLwnGAThq
         yiT2ML6hIFUQNPBybtj4lhpMeCIT76TW1WChM=
Message-ID: <c62985530810221044v342ce186x51d4c8eaf48a8ed8@mail.gmail.com>
Date: Wed, 22 Oct 2008 19:44:27 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: [PATCH][RESEND] tracing/ftrace: Introduce the big kernel lock tracer
Cc: "Ingo Molnar" <mingo@elte.hu>, "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <48FF628A.2080405@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48FF5E54.7000101@gmail.com> <48FF628A.2080405@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/22 Randy Dunlap <randy.dunlap@oracle.com>
>
> Please use the more common/accepted long-comment style:
>
> /*
>  * comment line 1
>  * comment line 2
>  */
>

Ok, I will correct it.


>                                         requests

Oops....


> what is <bkl_trace> used for?  or unused?

It is used on trace_bkl_acquire and trace_bkl_release functions. It is
really necessary
to keep a reference to the global trace array.

I can send a new patch with the corrections or send a new one which
applies on this one
if it is accepted.
As you want Ingo...
