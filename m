Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030465Ab0B0SSd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 13:18:33 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:56167 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030367Ab0B0SSb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 13:18:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=K8bn/hd9kZmeMf/ALjzn9f4LKd7kOT5XXQnqvWjR3x1C1g3RPgn+1/mFepmCKnCyOw
         CQqJsYNjheBZD7nP78W94ezi8sw8vtDUAsF9uNomHxjvPn9AL6GQdS9HZ+9v72ApCZ4E
         6pQBX7cNdhX8v1V8dQV5kg4DPef4RhLTwWnW4=
MIME-Version: 1.0
In-Reply-To: <201002262304.49768.david-b@pacbell.net>
References: <cover.1267225701.git.gardner.ben@gmail.com>
	 <6787cce8528c344c496724509762b2a11dea4bfb.1267225701.git.gardner.ben@gmail.com>
	 <201002262304.49768.david-b@pacbell.net>
Date: Sat, 27 Feb 2010 12:18:29 -0600
Message-ID: <808c8e9d1002271018w2e767635h8a810153939e622c@mail.gmail.com>
Subject: Re: [PATCH 2/3] cs5535-gpio: Use set_direction
From: Ben Gardner <gardner.ben@gmail.com>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org, Andres Salomon <dilinger@collabora.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Jani Nikula <ext-jani.1.nikula@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Use the set_direction method instead of direction_input and direction_output
>> to enable use of the bidirectional mode.
>
> Any reason you aren't making the standard behavior be:
>
>        input ... input enabled
>        output ... both enabled
>
> That would make this driver behave like most other GPIO hardware, which
> would help you avoid subtle problems.
>
> Would there be any technical downside to that approach?

That sounds like a good approach.

Ben
