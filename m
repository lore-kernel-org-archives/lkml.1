Return-Path: <linux-kernel-owner+w=401wt.eu-S1754716AbZCUWAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbZCUWAa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 18:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbZCUWAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 18:00:14 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:8499 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbZCUWAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 18:00:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=EVuPa0sx5OmPGkJRpgBJ7W3Vuujv9Hy60bKkzfdYY0DDgu2C3RGkvzRp7cwp7p2zNi
         B90jWMu4lLZ1WHZoOSSQML5JkX/Q9iD9RyRJwkWrTnn4E8eD34KFwb99JMNy7GugV2n6
         CFdgTfcaUI3EDUj9+xKP7Uae/3jMybNsfoFwQ=
MIME-Version: 1.0
In-Reply-To: <49C5486D.9020103@emcraft.com>
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>
	 <20090318192046.20375.89854.stgit@dwillia2-linux.ch.intel.com>
	 <49C26D91.10804@intel.com> <49C5486D.9020103@emcraft.com>
Date: Sat, 21 Mar 2009 15:00:10 -0700
X-Google-Sender-Auth: d225734551fe29bf
Message-ID: <e9c3a7c20903211500j3f1575e7o2ad9fb5969a2bdd@mail.gmail.com>
Subject: Re: [PATCH 06/13] async_tx: add support for asynchronous GF 
	multiplication
From: Dan Williams <dan.j.williams@intel.com>
To: Ilya Yanok <yanok@emcraft.com>
Cc: "H. Peter Anvin" <h.peter.anvin@intel.com>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org, neilb@suse.de, maciej.sosnowski@intel.com,
       Yuri Tikhonov <yur@emcraft.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 21, 2009 at 1:05 PM, Ilya Yanok <yanok@emcraft.com> wrote:
> Have you ever tested this code path?

Not this path, not yet.  Which is exactly why I am holding back the md
pieces.  We can collaborate on testing and stabilizing the api for a
kernel cycle before turning on the raid6 conversion.

--
Dan
