Return-Path: <linux-kernel-owner+w=401wt.eu-S1760730AbYEXDit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760730AbYEXDit (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 23:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758914AbYEXDil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 23:38:41 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:49928 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722AbYEXDik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 23:38:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=q3KTmrPWGlBI4Zr7uHpzUu5s0wy6ugWAwlItWx2mqfNJ3Scne/UO9gD56qI2huAe3HgB9IM3UK8lTN8369H3t6moc1f1rq60w0deCOH+NFKk2Rfh8eV318xLYzX6oK5g2z8xNm+TvF7m1YWofV59flUf/VeJT7HrC6EDka5mX48=
Message-ID: <a36005b50805232038j7746ee58l37830d6e14a4fb51@mail.gmail.com>
Date: Fri, 23 May 2008 20:38:30 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Daniel Walker" <dwalker@mvista.com>
Subject: Re: [PATCH 3/3] futex: fix miss ordered wakeups
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1211520987.18130.110.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080523042923.594531457@mvista.com>
	 <20080523042923.916202203@mvista.com>
	 <a36005b50805222202v6ea7b50p988eab5524935e1a@mail.gmail.com>
	 <1211519720.18130.98.camel@localhost.localdomain>
	 <a36005b50805222224g79477cb2md5298bbf4e35bcfb@mail.gmail.com>
	 <1211520987.18130.110.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 10:36 PM, Daniel Walker <dwalker@mvista.com> wrote:
> I think that ordering is something companies have been wanting for a
> long time..

That's your claim.  Again, almost nobody outside the realm of embedded
fortunately uses priorities.  It's a complete waste of time almost all
programs, certainly all but one or two on any of my systems.

There is already a solution for priority wakeup.  Use it and don't
punish everybody else for your needs.
