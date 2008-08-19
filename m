Return-Path: <linux-kernel-owner+w=401wt.eu-S1755413AbYHSQPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413AbYHSQPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 12:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbYHSQPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 12:15:45 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:22654 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727AbYHSQPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 12:15:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Wefav8cGvOaIlqM9DTc8SQDQ4iHJ3GAv3Fxgfrsa6WG2XnZoAp+fC2I+tPnhvY97YP
         76joW+uMWosnh0a35yhjn37yNsCZEEVFbvXscbkyRNOYcqBqhfGr4bKW6HCB7ihbPwnj
         7gsgyUiEWXf7nQcvQNivquMeXg8YkvO3375rs=
Date: Tue, 19 Aug 2008 18:15:19 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Kevin Diggs <kevdig@hypersurf.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Fwd: Corrections please ...]
Message-ID: <20080819161512.GA5401@joi>
References: <48AA27AF.9070407@hypersurf.com> <20080819024125.GM19760@disturbed> <48AA7F47.5050805@hypersurf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AA7F47.5050805@hypersurf.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 01:07:35AM -0700, Kevin Diggs wrote:
> Dave Chinner wrote:
>> On Mon, Aug 18, 2008 at 06:53:51PM -0700, Kevin Diggs wrote:
>>> Could someone ... anyone take a look at these kernel doc additions?
>> .....
>>> +/**
>>> + * complete: - signals a single thread waiting on this completion
>>> + * @x:  holds the state of this particular completion
>>> + *
>>> + * This will wake up a single thread waiting on this completion. If  
>>> multiple
>> Your mailer appears to be wrapping lines.
>>> + * threads are waiting ???
>>> + */
>>> void complete(struct completion *x)
>>> {
>>>        unsigned long flags;
>> complete() will only wake one waiting thread. If there are multiple
>> waiters, then further calls to complete() are required to wake them,
>> or a single call to complete_all() could be used.
>>> EXPORT_SYMBOL(wait_for_completion);
>>>
>>> +/**
>
> Take 2 ...

You might want to read Documentation/SubmittingPatches.
(Especially points 2, 7, 11 and 12)

Marcin
