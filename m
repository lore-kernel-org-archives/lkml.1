Return-Path: <linux-kernel-owner+w=401wt.eu-S1753443AbYEWLgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbYEWLgY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 07:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750851AbYEWLgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 07:36:15 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:13222 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbYEWLgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 07:36:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hoHegH5Q1ah9VH0Wx9Y5BnsgZeUrzUsxjZGGuosQy6pZBY7cX4wrVj4q3EyMoMLfENxTHhikoY5zy90bNzJusdOgxTdtN2qQn1SPqgf2E+jHx5MkxNDqcLDm8HsSQaSmziM8RUu+tTggM0PevLGnNSnwAiMV7uajYaNbc+JpISs=
Message-ID: <d1af83620805230436w28274e82tc98261b69ecd1330@mail.gmail.com>
Date: Fri, 23 May 2008 08:36:10 -0300
From: "Kevin Winchester" <kjwinchester@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] x86: Switch apm to unlocked_kernel
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080522212204.177410b8@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080522212204.177410b8@core>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 5:22 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> This pushes the lock a fair way down and the final kill looks like it
> should be an easy project for someone who wants to have a shot at it.
>

I would like to have a shot at this if no one else if currently
working on it.  This would be my first attempt to graduate from
testing (and a few simple patches) to an actual functional change.  I
would expect that the steps involved are:

- See what data is affected under the BKL
- See where else that data may be affected (including possible
parallel calls to the same path)
- Decide what locking is necessary
- Implement it (the easy part)

If this is about right (and I'm not missing anything major) - I will
give it a try and see where I get.

If, however, I have just proved that I do not have a full grasp of the
problem, or if someone else is already working on this particular path
- please let me know.

-- 
Kevin Winchester
