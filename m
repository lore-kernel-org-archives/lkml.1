Return-Path: <linux-kernel-owner+w=401wt.eu-S1756230AbZJVSRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230AbZJVSRu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 14:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755955AbZJVSRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 14:17:50 -0400
Received: from mail-pw0-f42.google.com ([209.85.160.42]:65525 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918AbZJVSRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 14:17:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ozqcS4F5ZqzDaZov8K8w9d6yAs/MoZ5LetVCdZHHRiVygIetj0xfg6az1elZkyeYKd
         huT4GnJYId+LQ2dc7z6XOzl0JNi82xkjLdDudG+wYoF1ZXmDIbfeoD9seTcd3qek3f2v
         hF+kWG+xVWPZAWBlhYuLhzNX41Gjjj0oqACGA=
MIME-Version: 1.0
In-Reply-To: <f22d86810910221046l366d3017r8b8823e4750ffea2@mail.gmail.com>
References: <f22d86810910220410r33002b5ei403ddf6632254472@mail.gmail.com>
	 <5048.1256224623@turing-police.cc.vt.edu>
	 <f22d86810910221046l366d3017r8b8823e4750ffea2@mail.gmail.com>
Date: Thu, 22 Oct 2009 23:42:08 +0530
Message-ID: <f22d86810910221112x75a908eewe015eb5eae883aa9@mail.gmail.com>
Subject: Re: Can current macro be accessed from interrupt context?
From: "Leonidas ." <leonidas137@gmail.com>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assumption
> here is a certain task can be in kernel mode only on one cpu at a time
> hence that task specific
> data structure can be accessed without locks.

This is pretty much like per cpu variables, right? Conceptually there
is no difference
in per-cpu mechanism and what I am thinking.

-Leo.
