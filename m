Return-Path: <linux-kernel-owner+w=401wt.eu-S1754783AbYLBMbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbYLBMbl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 07:31:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754519AbYLBMba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 07:31:30 -0500
Received: from mx2.redhat.com ([66.187.237.31]:57264 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667AbYLBMb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 07:31:29 -0500
Message-ID: <49352A9C.1070004@redhat.com>
Date: Tue, 02 Dec 2008 14:31:24 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Luis Henriques <henrix@sapo.pt>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] kvm crashes in 2.6.28-rc6-00007-ged31348
References: <20081130193401.GA7690@hades> <4932F59D.2060002@redhat.com> <20081130203833.GA14903@hades> <4932FB47.6090300@redhat.com> <20081130210406.GA17952@hades> <493528D8.8010904@redhat.com> <49352946.9050107@redhat.com>
In-Reply-To: <49352946.9050107@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Avi Kivity wrote:
>> - something did a read-modify-write cycle on cr4 (which contains the 
>> svm enable bit) while kvm enabled that bit
>
> Well, there are a couple of code paths that do this.  I'll look into it.
>

Sorry, that's EFER.  It could be something doing a read-modify-write on 
that.

-- 
error compiling committee.c: too many arguments to function

