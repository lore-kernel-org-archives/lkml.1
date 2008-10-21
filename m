Return-Path: <linux-kernel-owner+w=401wt.eu-S1754189AbYJURq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbYJURq1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 13:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbYJURqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 13:46:19 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:20999 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbYJURqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 13:46:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=q701VdfWIaOVhG3hgcMA6CDugZi+ywqdhF4JApiQEgbRGBDEuyJ/IFeBJpGsKjkBNm
         4q01zQSMCzAcUAdUSzNZR/paC6tJY1D0ysRAXlUzUYDxmtw5j05TDfbKwYVKmjiOT8Fb
         tkZM4En1r+55FAMnqf3YBZUZGnmFeE+ODIpAM=
Message-ID: <8bd0f97a0810211046n2e32868fu1a58cc9123da7c6d@mail.gmail.com>
Date: Tue, 21 Oct 2008 13:46:18 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Jesper Nilsson" <jesper.nilsson@axis.com>
Subject: Re: [RFC] CRIS: Move header files from include to arch/cris
Cc: "Sam Ravnborg" <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       "Mikael Starvik" <mikael.starvik@axis.com>,
       "Bryan Wu" <Bryan.Wu@analog.com>
In-Reply-To: <20081021164211.GG24715@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081021164211.GG24715@axis.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2008 at 12:42, Jesper Nilsson <jesper.nilsson@axis.com> wrote:
> That means that the machine dependent header files are moved to
> arch/cris/mach-{fs,a3}/include, while the common and architecture
> dependent files are moved to arch/cris/include.
>
> It is mainly this I'd like some input on, since most other ports
> that have moved their header files have put all headers in arch/*/include.

that seems like a fairly obvious good idea to me ... i'm thinking we
should do it for Blackfin as well ...
-mike
