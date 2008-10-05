Return-Path: <linux-kernel-owner+w=401wt.eu-S1754739AbYJENYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbYJENYa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 09:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbYJENYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 09:24:21 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:10465 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025AbYJENYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 09:24:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ASdVG8XEarJX5VMqZnSpT5C/ZAFqIr4vEk4XRQdgAqOvb8f1N+1dG8dBrjljUkB/yE
         Ub9u2XrQfhP/mvhf/r1Rh4b/lqG/be8lZt12hoYPXdm0prR6CDoS7ycUmB+ZDcmHToGx
         zcCo4/9FU+LyuAakGIf2p7u/GdbHu6vx6I5t0=
Message-ID: <3fedcc3b0810050624m19bfd701n82b70ca81887c3fc@mail.gmail.com>
Date: Sun, 5 Oct 2008 11:24:19 -0200
From: "Thiago Lacerda" <thiagotbl@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Questions about mmap
In-Reply-To: <3fedcc3b0810050621y3f44417ag605ee75dd0389100@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3fedcc3b0810050621y3f44417ag605ee75dd0389100@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,
I'd like to share a hashtable among kernel and userspace.
The hashtable resolves collision by chaining.
I have the following structure:

typedef struct flow_t flow_t;

struct flow_t {
   ...
   ...
   flow_t *next;
   flow_t *prev;
};

typedef struct hashtable {
   flow_t *hashBuckets[X]; // X is a natural number
   unsigned int size;
} Hastable;


So, my question is: Can I mmap the hashtable struct and access
directly from userspace? I'm afraid that this could turn on mess
because of the array of pointers.
If it's possible, does anyone know a piece of code that can match my
problem? I've been googling and I just find codes dealing with structs
itself, not pointers.

Best regards


--
Thiago de Barros Lacerda
Computer Science Undergraduate Student - CIn/UFPE - 2004.2
Researcher/Software Developer - GPRT - Networking and
Telecommunications Research Group
