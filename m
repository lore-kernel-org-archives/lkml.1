Return-Path: <linux-kernel-owner+w=401wt.eu-S1755218AbZIMVmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbZIMVmF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 17:42:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755178AbZIMVmC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 17:42:02 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:61850 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942AbZIMVmB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 17:42:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pVv9h6xCecndVUogfwfaM9V3bMup5iRmV+8u+ryOEkkKY38trA9sfzsTpJ8HVfHfQD
         YEl3ZYn2U3lBadWtMoAgX0Lz5YIhakSh8c9lrcUOwEXquiVYlzUQlm3U2uviUf8WY2O+
         KzuNCbwXAkwTw9X5QNeTXxed8mj3GrYj9v5do=
MIME-Version: 1.0
In-Reply-To: <8bd0f97a0909131412v6ba29823ube9aab20302aaca0@mail.gmail.com>
References: <1252870707-4824-1-git-send-email-felipe.contreras@gmail.com>
	 <1252870707-4824-2-git-send-email-felipe.contreras@gmail.com>
	 <1252870707-4824-3-git-send-email-felipe.contreras@gmail.com>
	 <8bd0f97a0909131412v6ba29823ube9aab20302aaca0@mail.gmail.com>
Date: Mon, 14 Sep 2009 00:42:04 +0300
Message-ID: <94a0d4530909131442h43d0ed1cl9f395f7d38f2c43@mail.gmail.com>
Subject: Re: [PATCH 2/5] kbuild: fix warning when domainname is not available
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 12:12 AM, Mike Frysinger <vapier.adi@gmail.com> wrote:
> On Sun, Sep 13, 2009 at 15:38, Felipe Contreras wrote:
>> +  if $domain; then
>
> is this really correct ?  i think you meant to use:
> [ -n "$domain" ]

What is the difference?

$domain unset
test -n "" -> false
test -> false

$domain is a valid string
test -n "string" -> true
test "string" -> true

The relevant rules are these:
* An omitted EXPRESSION defaults to false
* STRING equivalent to -n STRING

-- 
Felipe Contreras
