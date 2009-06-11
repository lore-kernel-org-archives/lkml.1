Return-Path: <linux-kernel-owner+w=401wt.eu-S1758820AbZFKAms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758820AbZFKAms (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 20:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbZFKAmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 20:42:39 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:53955 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbZFKAmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 20:42:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=x/safnl0Sg6A9aX3Glupih8GxQWsv+WNeiC6KZ+sLb7BmreAuB9YKInTTukvZJ0c3f
         thpX9m46kwq4zaOyEYwUdZ60zNirwHMAOL6qEuTVpsylc+MyyUXlygqYyJ/x7M6wB78I
         AZx3wKYwIsnb/F5ELktPXfdbBTN1wUh+4hydg=
MIME-Version: 1.0
In-Reply-To: <9b1675090906051257t5aad47capccfcf1c94f863a66@mail.gmail.com>
References: <1242496922-6330-1-git-send-email-fweisbec@gmail.com>
	 <1242496922-6330-2-git-send-email-fweisbec@gmail.com>
	 <9b1675090905292005p2b53de7dy9e36f84368d76f01@mail.gmail.com>
	 <4A296343.4050005@suse.com>
	 <9b1675090906051206we136e88k6a14194963726709@mail.gmail.com>
	 <4A29723C.2030102@suse.com>
	 <9b1675090906051257t5aad47capccfcf1c94f863a66@mail.gmail.com>
Date: Wed, 10 Jun 2009 18:42:38 -0600
Message-ID: <9b1675090906101742g64263889j1c4eb47f894072c4@mail.gmail.com>
Subject: Re: [PATCH 1/2] kill-the-bkl/reiserfs: acquire the inode mutex safely
From: "Trenton D. Adams" <trenton.d.adams@gmail.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Reiserfs <reiserfs-devel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Alexander Beregalov <a.beregalov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have not been seeing this with 2.6.30-rc7.  Perhaps it was resolved
in that version.  I'll let you know if it happens again.
