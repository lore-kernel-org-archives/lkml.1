Return-Path: <linux-kernel-owner+w=401wt.eu-S1763681AbYARSSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763681AbYARSSi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 13:18:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760917AbYARSS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 13:18:29 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:28619 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757642AbYARSS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 13:18:27 -0500
In-Reply-To: <4790E227.506@redhat.com>
References: <4790C756.2040704@redhat.com> <63F84201-9D38-4588-B237-A15138E94C5A@oracle.com> <4790D9F3.2070503@redhat.com> <451AC300-674E-4DBE-869F-08A9184051B3@oracle.com> <4790E227.506@redhat.com>
Mime-Version: 1.0 (Apple Message framework v753)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <247ED9F6-F190-4493-B5BA-76A2904179F4@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-nfs@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Chuck Lever <chuck.lever@oracle.com>
Subject: Re: [PATCH 0/3] enhanced ESTALE error handling
Date: Fri, 18 Jan 2008 13:17:24 -0500
To: Peter Staubach <staubach@redhat.com>
X-Mailer: Apple Mail (2.753)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter-

On Jan 18, 2008, at 12:30 PM, Peter Staubach wrote:
> Chuck Lever wrote:
>> On Jan 18, 2008, at 11:55 AM, Peter Staubach wrote:
>>> Chuck Lever wrote:
>>>> Hi Peter-
>>>>
>>>> On Jan 18, 2008, at 10:35 AM, Peter Staubach wrote:
>>> and the window in between the revalidation
>>> and the actual use of the file handle associated with each
>>> dentry/inode pair.
>>
>> A use case or two would be useful to explore (on linux-nfs or  
>> linux-fsdevel, rather than lkml).
>
> I created a bunch of use cases in the gensyscall.c program that
> I attached to the original description of the problem and my
> proposed solution.  It was very useful in generating many, many
> ESTALE errors over the wire from a variety of different over the
> wire operations, which were originally getting returned to the
> user level.

The gensyscall.c program is what I would call a set of unit test, btw.

This is not the same as a use case, which would include information  
about the application environment, its users, a detailed description  
of current system behavior, and some discussion of alternatives for  
improving it (including doing nothing).

A test case is written in a programming language, a use case is  
written in a natural language.

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com
