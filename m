Return-Path: <linux-kernel-owner+w=401wt.eu-S1765494AbYJKHCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765494AbYJKHCs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 03:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757974AbYJKGme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 02:42:34 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:47428 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759379AbYJKGmd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 02:42:33 -0400
Message-ID: <b2cdc9f30810102342t5bb07d82m94a4bffab2b68673@mail.gmail.com>
Date: Sat, 11 Oct 2008 07:42:32 +0100
From: "Alex Bennee" <kernel-hacker@bennee.com>
To: "=?ISO-8859-1?Q?Bruno_Pr=E9mont?=" <bonbons@linux-vserver.org>
Subject: Re: rtl8169_get_stats seems to be adding random crap to rx_missed_errors count
Cc: linux-kernel@vger.kernel.org, "Francois Romieu" <romieu@fr.zoreil.com>
In-Reply-To: <20081010232724.1447f915@neptune.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <b2cdc9f30810100947s699dbc76ia72023b08e064816@mail.gmail.com>
	 <b2cdc9f30810100953i680c2d02s8352bb109d494bf1@mail.gmail.com>
	 <20081010232724.1447f915@neptune.home>
X-Google-Sender-Auth: 363ea28f42f3da2b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 10:27 PM, Bruno Prémont
<bonbons@linux-vserver.org> wrote:
> Hi Alex,
>
> This issue has already been reported in
>  http://lkml.org/lkml/2008/10/9/235
> and a patch exists.
>
> Could you verify that patch #0009 at URL below fixes the issue for you:
>  http://userweb.kernel.org/~romieu/r8169/2.6.27-rc9/20081007/

I can confirm that patch works for me. I have further reviewed the
code and it looks OK to me from here. Should I just forward the patch
and tag it to the mailing list or is it now in a tree that gets picked
up?

-- 
Alex, homepage: http://www.bennee.com/~alex/
