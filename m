Return-Path: <linux-kernel-owner+w=401wt.eu-S1758528AbYAJEjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758528AbYAJEjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 23:39:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755801AbYAJEjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 23:39:05 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:12826 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569AbYAJEjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 23:39:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=js7KQyofPhxVYtOZqsX8ecJOn5AT0cDfcbEumSgkUpCbLGWakTzRf34jGOoG0iUyD3SKjlr5vKYTe7EN65eNzIhEfJWtgGqMDa0En0KFNDnlpr2Y3z4LHeNG+nMCGX+HE8+hHgeDwIfZc/2HKLzN212A6LsCIPeK24YnMDFZJuY=
Message-ID: <170fa0d20801092039w22584e2fw6821e70157f55cae@mail.gmail.com>
Date: Wed, 9 Jan 2008 23:39:02 -0500
From: "Mike Snitzer" <snitzer@gmail.com>
To: "Rik van Riel" <riel@redhat.com>
Subject: Re: [patch 00/19] VM pageout scalability improvements
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20080108205939.323955454@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080108205939.323955454@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 8, 2008 3:59 PM, Rik van Riel <riel@redhat.com> wrote:
> On large memory systems, the VM can spend way too much time scanning
> through pages that it cannot (or should not) evict from memory. Not
> only does it use up CPU time, but it also provokes lock contention
> and can leave large systems under memory presure in a catatonic state.
>
> Against 2.6.24-rc6-mm1

Hi Rik,

How much trouble am I asking for if I were to try to get your patchset
to fly on a fairly recent "stable" kernel (e.g. 2.6.22.15)?  If
workable, is such an effort before it's time relative to your TODO?

I see that you have an old port to a FC7-based 2.6.21 here:
http://people.redhat.com/riel/vmsplit/

Also, do you have a public git repo that you regularly publish to for
this patchset?  If not a git repo do you put the raw patchset on some
http/ftp server?

thanks,
Mike
