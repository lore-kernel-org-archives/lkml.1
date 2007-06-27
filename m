Return-Path: <linux-kernel-owner+w=401wt.eu-S1758902AbXF0Dsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758902AbXF0Dsd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 23:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbXF0Ds0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 23:48:26 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:1759 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbXF0DsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 23:48:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RU8O08H0zhKY00gDYmJD7jnc3pQeAKXkp9dCoO5S01o5ZeUxnK3VvWulhaGyRShUPs6u2bsZjT0Fky12L1NW65Jyr1tP+wm34Z6ycZU9Ek5lW9g+ifkyvJhA1cZWrcdaHWMpzXWLJ5qHyHaK556l7T05hP+qkN1RzX9/LK1WhOU=
Message-ID: <a36005b50706262048y5eb8ba80kb0d852d649d1ac10@mail.gmail.com>
Date: Tue, 26 Jun 2007 20:48:19 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: [patch 2/3] MAP_NOZERO - implement sys_brk2()
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <send-serie.davidel@xmailserver.org.29496.1182912260.2>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <send-serie.davidel@xmailserver.org.29496.1182912260.2>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/26/07, Davide Libenzi <davidel@xmailserver.org> wrote:
> The following patch implements the sys_brk2() syscall, that nothing is
> other than a sys_brk() with an extra "flags" parameter.

Shouldn't we wait for Linus' sys_indirect to arrive and make this
another syscall which takes advantage of it?
