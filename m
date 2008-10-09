Return-Path: <linux-kernel-owner+w=401wt.eu-S1759936AbYJIOKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759936AbYJIOKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 10:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753512AbYJIOKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 10:10:36 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:55943 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbYJIOKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 10:10:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xaimROTsgbkHsdlPYo9uwRZ+RjgP141kr59a43mHEAH42wJtNDS9Tc1olY9LVIYr6M
         frnMt7k/BDpEGgOO0cSmaL2UItnDtgi83ZP3Ew1lQqXH0eFwfkrY0KpwFU5xBU1NZPpV
         CjeO+Z/y/47RoKcnV4OAGLSq7TUA7GwleTJKg=
Message-ID: <a4e6962a0810090710o2fec824dwb78660098b68ef50@mail.gmail.com>
Date: Thu, 9 Oct 2008 09:10:35 -0500
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "Latchesar Ionkov" <lucho@ionkov.net>
Subject: Re: [V9fs-developer] [PATCH 04/10] 9p: move dirread to fs layer
Cc: linux-kernel@vger.kernel.org, v9fs-developer@lists.sourceforge.net
In-Reply-To: <f158dc670810090640s408626f6mc787cb96efeb155a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1223500147-19654-5-git-send-email-ericvh@gmail.com>
	 <f158dc670810081510t3b5be588v8298aa20a26039c5@mail.gmail.com>
	 <a4e6962a0810081612i7f30ec16gf727da56816530ab@mail.gmail.com>
	 <f158dc670810090640s408626f6mc787cb96efeb155a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 9, 2008 at 8:40 AM, Latchesar Ionkov <lucho@ionkov.net> wrote:
> I don't think that there is anything at the moment that uses dirread,
> but the remote framebuffer that Abishek is working on uses some other
> of the client operations.
>

Ah -- okay, I probably need to sit down down with him over email and
figure out what he's using and what he needs -- the client functions
interfaces haven't changed, but some of the ways in which reads and
writes work has which might mess him up...

        -eric
